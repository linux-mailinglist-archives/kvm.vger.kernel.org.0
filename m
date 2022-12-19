Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF312651224
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 19:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbiLSSmb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 13:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbiLSSmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 13:42:19 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF5212A89
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 10:42:18 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJHxKlQ027756;
        Mon, 19 Dec 2022 18:42:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ExOmhDlusKXWDxVpLF84OeYFiOOROsjVw5/nmhqhVfQ=;
 b=yHFojUTwQ4AX+kvS77GubMimgoLgvbCK8XcnGkgzTFHRFDCIuvcMSEaSexCrxl4aiDTg
 v80eX8eADvCtaAJqNQnqyyX/rkWulwrB3WCosjYH3sa7u6m73j+oQlsbSDZBUWo5EA+3
 Q/F4/RC8NfB7dFB8p4BnGAXStRUiGs4VmbBKfa531za+LMu0lyZ8drCfgFrX+wkAjOUh
 mBt4rAPW3p+VqD749kFCFKn0inv3+jf+H+zDnFQdT3euBYdezmkEwEjZxmrFpeMfnhA+
 l+xXto3xBRhyUTQTOP6AEodk/YlWG1sFdHosV3lLVZ+OFhZu77t4p/Ahly2rrCsq444J zQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tmukja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 18:42:13 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BJHt3t7008197;
        Mon, 19 Dec 2022 18:42:12 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh47ax7je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 18:42:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+pWU0uLiTrOM8qfraoAHUPX1BRxZG0sctW/D1a6s06JOGj9ei1aot0VOVS6MYkSAKQL45JnIxMpqNkcEgyFctXMC+cLtlRxj4OFf7aE12OBwxUJx2PjTjT6urH6JPd+aVtAPKIQpvhelHil1KU/vbM4douJvnShEiREVPA92MkIUgrLrIzqMuRVLWMd6iUkUeqEBvJpxw44FqsmQMWhI4pOuKAXzT6zZllTAxbW4Bzxvkq0H91gg6mpoQmzujlN3jkTipyWy+CestvXJSvK0rllS6uIV/8KeqnHP59KN8TBFU5nax/w+tlS+jiVi0MZxLSs2jkhy7xbgBwo+2Wy4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ExOmhDlusKXWDxVpLF84OeYFiOOROsjVw5/nmhqhVfQ=;
 b=kzZlj6RCUxWZPxOHGQViH0ZF8azmL379pNguZgJ7R5V4tXdtmybQfJcRWVEeC0+pNrA/hfnEKG9dmivyjyIB6ZRS30waoqe5OBP0HutTp+mxXYfCFIxu5m7Y/wD5I8Y6LWkFfvTsH8UlB+ceIgnADNnaHVuBhsjSzLYeoKTncoxOULqbpne9OnHFsSTSlnfTh8d48CIfmFB5LkQFrqbYoPao3+SVCh5w3OixkSvLIdnM+t81pbq56T4YX8V2aYQpJjMGZF69AI9IPwzKURfpRJv80lakdcg+HnvAetDZrTf6MJr6xpQi/0q0PrZHYzf0EZ2WWz5ZIUp7KMQONUf2cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ExOmhDlusKXWDxVpLF84OeYFiOOROsjVw5/nmhqhVfQ=;
 b=gJmXzLldDqMzSfvHL3PCD1sApTcOO33efTXd33qAwGG21wnUUnSK8xG7S5zgzU4NtOqEZiRSOvoCBapwk8m7hfCunbWMOg0u1O2BwnLm5wadJsFqCSnboA8zlTR5sN5o/ZpJ5qYAi3/u1DKpqPkq3CQGtpz7/kINKpzUucnb5B4=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by CH3PR10MB7260.namprd10.prod.outlook.com (2603:10b6:610:12e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 18:42:09 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca%9]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 18:42:09 +0000
Message-ID: <247466ea-65a9-0b57-a85d-2ef5a700a48e@oracle.com>
Date:   Mon, 19 Dec 2022 13:42:06 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V6 0/7] fixes for virtual address update
Content-Language: en-US
To:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
References: <1671216640-157935-1-git-send-email-steven.sistare@oracle.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <1671216640-157935-1-git-send-email-steven.sistare@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:806:f2::14) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|CH3PR10MB7260:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b1ad96d-266f-4573-8a78-08dae1f0bc3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vZLiVM/fB8Nh9o0Q+w1zEFqCv3qTiJsLYoWG68WDvXQbG/l8oBQ2YU/osiWagKQ2y6yTIqCGesmzv1biAxlIaNC3qp32va2OJOy2L2rfomu3FdGBXh0yUi0imfuDotnAYmLr3ZH1BkQVFoHZ8eF3rtlo62q8o6u3So36Ks2bOdPFokEdqm7Y3jvaxlrgrXFQc13cdGeDtiw0nd9EOrZQtvGjn6sPmFVTrLpJ5+KmTgcsluT60UuJEmoEavQmq+Ee+VSx5+a9BX1vp9+dqNjLd6cC1elqAWU7HMzNiXJaYtZGDg+gAI2VfUq5DAUjkbZMZAP7OYKMAtAx9+O5ilXZy3Nu3pr0qGj//9c5sfZWJOdT+yU7ib+Hgj8ORJRpLxuSiEg0AvGUvxZ+q9PiFhQRQUr2UHh4BQjMYgQXp52I5w8I0W2wCB4S4hvYUUQfudVi+peKZx54lvD621aEbCDFyw6SM8z6Mkgv4VHy3K3nxwKGL5ERxiIgwBwyURo7APhJaN2cYbjuB87eUMC7RlqL29PTRvzc3CGD1/8aiIBy8CJ740rSQYt/eLRWuoXAThs918KURIH2KdVHkn8JasxzpsNHEvINm/r02X2G/RpfDzscJDBjCH2hcgM0yf1nBuIYfjxrT9kzUKnuHExrS4H/novXqd5hbXdEwpTAp4kdX4SNbfrfbwfKpAcdnHkm7vu2+DjM9zqHCS3weH3AJCTft2g3OEtZu0VHgV0Er5jcHUw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(39860400002)(396003)(366004)(346002)(451199015)(36916002)(38100700002)(6506007)(53546011)(26005)(6512007)(186003)(2616005)(478600001)(6486002)(83380400001)(6666004)(36756003)(31686004)(41300700001)(15650500001)(316002)(110136005)(8936002)(2906002)(66946007)(86362001)(4326008)(66476007)(44832011)(5660300002)(31696002)(8676002)(66556008)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzgxUkYvbjkzbUI3MEEyN0FaUnB0bWozWEZHMG9DQStubDFneHhOckJTRkIv?=
 =?utf-8?B?b25pd01zWC9iY3VYekN2MlVBd1BRUVV4dVhIVWlPQnJHNEtYa3dUdU9SWUZH?=
 =?utf-8?B?ekhlWC9acURDSkl6NkVIVWN2Z1V3L0FkbG5rVGQ0cWxIUENZYmsybjhRTXZK?=
 =?utf-8?B?QW9Rc1VpM2hnaTVWV09rUW1HcFlBYllkRzVtZ3FxYnIzeU9PVzFEelhBdGdC?=
 =?utf-8?B?ZSs5T25ueEFqRGUvSWU0Q3N4NCtqRm9oVVpDZytLUEI5UzdnTTJyWDhtdGdm?=
 =?utf-8?B?YURqKzFIak5vMEU5Y0ZNd0wvaUM4aFZTUExGa0tJTW13MFM0RW5JT2tLbDZU?=
 =?utf-8?B?Q3Qrd1cvUU52TW0zUW5GS3lpck5MTGpXV0VxNGx0OWRJTGh2ZHlLVW0yN0pZ?=
 =?utf-8?B?OWRLMk16VHdFOW9oYXQ5S0F6eDA3L2dIUHQ4N1VNbDhrNno1TWtJVWR5OHRF?=
 =?utf-8?B?M3RxMXlpL0R1YVJRc05CTVNGWEpjRVQ4WjFYeWxvOGZ0VGs3cDljNW45RHp4?=
 =?utf-8?B?a2ZlM3hpNno1NEppUitxUnU4dkJwTlcwUWYyREZQZWlPNmViREpkVDRJaG1l?=
 =?utf-8?B?R0w2TDM3eGV2aDVBcThVQ1VYTlRubDJYSnFtRnBIWWsxaUwyS2QxdUJab1dk?=
 =?utf-8?B?MEY4R3BhYVZaSEpQRVRUcHBTajkrdm5JMWpmR1ppZUMvZWdHT2xhUzN2Nmk4?=
 =?utf-8?B?K1RZOTZ2SWF0LzZoNXBqNndOSGdQWnpKa1d2NDNYNXNyTnhFcHZMVDFOQ09S?=
 =?utf-8?B?R0Z4dXFNNVdiUUdWTlJBaTFqaGY3bUFrWXFaZlZQSFNQTjNROHY0d2FWeTVU?=
 =?utf-8?B?VlluUy9SY1N1Ym1iV1JWUCs3NFZFdHlTbm95U2NmVE1Sem9sVzhNRVlscTVH?=
 =?utf-8?B?ckRrQ2c0dDBlY3BMTHl3SUxxaVBZMy9hSnFlNS9QUE9Sbk9uYzFtQXozd1Bs?=
 =?utf-8?B?MFdydWh2R3Z6eWEvazdpV2JVbWxEWUN1OGJRMklFWWNLMnRONGVSbTZYL29n?=
 =?utf-8?B?TUhoL2taMytRZHBOVnBjcWRDL3dPWlpuWnQ4ZDQ2ODlyRGtzT28zbnp0b29t?=
 =?utf-8?B?Y3VWamo3NVo3SUo0UXZZd1JrQngwaVdKSWt3TWtUdFRvdFBsYVVJRnBzdjBQ?=
 =?utf-8?B?Sk9kQzZpd1NmOXorTXdTTUxIdm5ibkJqSmxmZzRERGxyUFpuR2ltS05LdEZj?=
 =?utf-8?B?V0ZxR28rc3hDMEJ6dWZodlpKVzdyLy8vVHRIOHBZQUkvQXZEQ3BPa3VwQXVi?=
 =?utf-8?B?YkRYcTZMdC91b3JjbjlHME5RM290UTVBWm4vd0pDRXl0bS9zUlcrMUdtUE1z?=
 =?utf-8?B?TUhrTVdKeTRPS21QbjVpcXlFdnFGdDlTNldERXd5THJmRFBPQnE1Q1A4TmtU?=
 =?utf-8?B?Mk83Z1J4U3pqblFMQjlzQXBjakJDTXNlNkVYOHEwOGNtU2ZqV1Q3Vm9oMzNJ?=
 =?utf-8?B?dE5wSlFpQ09aMzdKWXljNTk2emZkZHIvcFBJY1dIbFdwWVFaMkg2RDArQnU2?=
 =?utf-8?B?UGswVDdMVE93ZXlqUzJJZ2I4U1BWbjRnMVFPRGNkbEN2VjN3SUtIQXVBSGgw?=
 =?utf-8?B?M1RNeUxTOXZ5SmZLa3dITnN2ZGkrZ0FoRjZvQjhMa1pEUEI1ZmtsaEp5Mmtr?=
 =?utf-8?B?SmFaWmJDRVYrUmhkYUF5RUFWY2IxL2t3NUM2VkM4T2lRSElVWVZjWExyeWw3?=
 =?utf-8?B?MjROMUFPb0dpbGlpU1A0YllCM3drZFpHenhIcjZFMDRxVFVKbGRScXgvSEI4?=
 =?utf-8?B?TmJUc3hJQ1U0ZUEwbWJMWE9OTGZncmZJNklJdnlmMHlVdEtTK214VG5HTkJI?=
 =?utf-8?B?V21LRFVKcUM3LzJJbHoxWlhRQmFSNm9uUHg5UVdhRHI3RGs3L1VvbEloUjhD?=
 =?utf-8?B?QTQwY2tKem1YSys1Y3Z2UTNoellhRWhlSkFLRzdiOVYySjJETDRBdVhjekpk?=
 =?utf-8?B?d1J1Y3ZqL3krUG5jdVBpU3QvdEJuR3NNL3dmMmNtVjMvTXFJNXVDVW4veVA1?=
 =?utf-8?B?RDFiaUlDQy9NeHFlc05oSG1TbkFscHVuang5OXpUS2UyeUFxUVRPdlNXWDlt?=
 =?utf-8?B?SVIwUHFycHBodC90Tm9XVWZDaGFxMXJXN2NJcFdQVzVXN01VRXZuSGJNd1VP?=
 =?utf-8?B?emtQSmRZVHEza2ozaGhDVUtITG5wR2Mxd1R5bGxDNHZJWXNneC9Ock1PTWlN?=
 =?utf-8?B?RGc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b1ad96d-266f-4573-8a78-08dae1f0bc3a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 18:42:09.4106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fr0u89ENtwayF5QoiaPX0PY+CAQKQsmZPtdJEzEymknVUfRleg3/h6GHz7A353e7kl3yCT9QyAZ1bHFG/AL+Q7rMVeNV+2Qzj0oShiLWjOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7260
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212190166
X-Proofpoint-ORIG-GUID: 2XNbZGFEod_VTuX_OkE5UxDaox8lSOdk
X-Proofpoint-GUID: 2XNbZGFEod_VTuX_OkE5UxDaox8lSOdk
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alex, Jason, any comments before I post the (hopefully final) version?

- Steve

On 12/16/2022 1:50 PM, Steve Sistare wrote:
> Fix bugs in the interfaces that allow the underlying memory object of an
> iova range to be mapped in a new address space.  They allow userland to
> indefinitely block vfio mediated device kernel threads, and do not
> propagate the locked_vm count to a new mm.  Also fix a pre-existing bug
> that allows locked_vm underflow.
> 
> The fixes impose restrictions that eliminate waiting conditions, so
> revert the dead code:
>   commit 898b9eaeb3fe ("vfio/type1: block on invalid vaddr")
>   commit 487ace134053 ("vfio/type1: implement notify callback")
>   commit ec5e32940cc9 ("vfio: iommu driver notify callback")
> 
> Changes in V2 (thanks Alex):
>   * do not allow group attach while vaddrs are invalid
>   * add patches to delete dead code
>   * add WARN_ON for never-should-happen conditions
>   * check for changed mm in unmap.
>   * check for vfio_lock_acct failure in remap
> 
> Changes in V3 (ditto!):
>   * return errno at WARN_ON sites, and make it unique
>   * correctly check for dma task mm change
>   * change dma owner to current when vaddr is updated
>   * add Fixes to commit messages
>   * refactored new code in vfio_dma_do_map
> 
> Changes in V4:
>   * misc cosmetic changes
> 
> Changes in V5 (thanks Jason and Kevin):
>   * grab mm and use it for locked_vm accounting
>   * separate patches for underflow and restoring locked_vm
>   * account for reserved pages
>   * improve error messages
> 
> Changes in V6:
>   * drop "count reserved pages" patch
>   * add "track locked_vm" patch
>   * grab current->mm not group_leader->mm
>   * simplify vfio_change_dma_owner
>   * fix commit messages
> 
> Steve Sistare (7):
>   vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
>   vfio/type1: prevent underflow of locked_vm via exec()
>   vfio/type1: track locked_vm per dma
>   vfio/type1: restore locked_vm
>   vfio/type1: revert "block on invalid vaddr"
>   vfio/type1: revert "implement notify callback"
>   vfio: revert "iommu driver notify callback"
> 
>  drivers/vfio/container.c        |   5 -
>  drivers/vfio/vfio.h             |   7 --
>  drivers/vfio/vfio_iommu_type1.c | 226 ++++++++++++++++++----------------------
>  include/uapi/linux/vfio.h       |  15 +--
>  4 files changed, 111 insertions(+), 142 deletions(-)
> 
