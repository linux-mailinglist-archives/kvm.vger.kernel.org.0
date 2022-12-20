Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 759B865235A
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 16:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbiLTPCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 10:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbiLTPBi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 10:01:38 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9872762CB
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 07:01:37 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKDJDGq030775;
        Tue, 20 Dec 2022 15:01:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=VmDGUkAPhwWKeVVt9uV1stzYwc2VEaNiAiSUUq0Gl7w=;
 b=Aks1g8sObVQL+O7Ou7KL00kkR3gM88h3tmP0GFzQN96EDt0db4BY8CKLMP4FFNN2umCK
 cb0PAzVa3rF73anUKBloEmOUuaSdCca9l3nOb0pWPQ/UHba2P+C3nNVpi8cwD12DtxIH
 cK3tdmllY2o+QpN2ApQPVdwL1Hj/+3kaxrToTBFspXlpHLAvLnr78kwwgYGUKDqRcyJn
 UbLumb3acfHiw14SmzXfFxB4pLGF+aYdFZLkZUNGDAvdO++8QKOtmnv4Toz9UrrfKvQv
 wLClG0RPWKuTSE4dXSKKn91sAc+vsg7DwKEp5SsJORucFmXF/xicQ3BJXMfJADwNAyRE pA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tqx3a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 15:01:29 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BKEvNch027631;
        Tue, 20 Dec 2022 15:01:28 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh4755mk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 15:01:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mrf4CKcclKstVkhfKd2Xc5qz0evo8VAUhaQfK2NS6IYvlXchA5DNAPe41Q3CVZFdc0VuidO0DergJa180lrU1hiDNYkfonomKNDCXp0Fd9hloBoXqcRBnRRnWXoRpioutByjJrzR0Naa/QqyturCcUrpjvyfAOg0zC91iESgkA1DzELGKiXkXS1nh4WLUScP9lv7ah1BIWBpKV5BuPPS2+7CTygE8evmz1ohbQt9ZhLvt8eitIHhJ7w76Oh7sGAhcYsE6q73yCTfFRRbR6xB1kTqrIsNRjZS39kTh8FyNb5rZ6+9KjjCGmyY0fNTSdFYfeEcfvBIL2Y7J38AMi46/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VmDGUkAPhwWKeVVt9uV1stzYwc2VEaNiAiSUUq0Gl7w=;
 b=h/I8nwhwZGVVZwOdmD2vJXNAQ4JakqIK7PlgY4RbjrhVQuqB4tkYBCEXlZLMiJTpGfYjE/CE1ECqBleMFiCCmZxqZ5SLwEThNERdPBiCIhBfbTyut2u4o5FR+fUI6jtJj47tHOR2+S0SQDOuvPEdgLCwjwfO+qN9wTW1Rxel3In1IAIpOXiC71zFHJl1kor5danrZMngrNSJSzFAfEXcnYu5NyVODqn/kV73lu2n+ZRsbE8lLomPLeiedDQFPBDjpEo1Ia+BEUFpciH4uBYtmZOigubZvgLLYm02oNbNgVzl3TfFaKuAUzk4Eto804Pul+krsEr3ObRLXMCVK8+a2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VmDGUkAPhwWKeVVt9uV1stzYwc2VEaNiAiSUUq0Gl7w=;
 b=U+2a7lTjRhLcDrTeKyGfcfbHvzPEBd4VALrs+tZJXoM3Dx/9KxpjOt7gy1TMc7rX2u52RgW399TWNXDDZlD97dcS0Phv0WkX6qbB2AizGfxccoCKK+hvR02kPFp3EsMZlEwplNqwvbVjq9hBZP7PGYaorCei+jRtBIqWR/zC3yo=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by DM4PR10MB5944.namprd10.prod.outlook.com (2603:10b6:8:aa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Tue, 20 Dec
 2022 15:01:26 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca%3]) with mapi id 15.20.5924.016; Tue, 20 Dec 2022
 15:01:26 +0000
Message-ID: <f2af6106-7898-b96c-000e-92e84190ee54@oracle.com>
Date:   Tue, 20 Dec 2022 10:01:21 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V6 2/7] vfio/type1: prevent underflow of locked_vm via
 exec()
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <1671216640-157935-1-git-send-email-steven.sistare@oracle.com>
 <1671216640-157935-3-git-send-email-steven.sistare@oracle.com>
 <BN9PR11MB5276E8FEF666B4E7D110DE278CE59@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <BN9PR11MB5276E8FEF666B4E7D110DE278CE59@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0007.namprd08.prod.outlook.com
 (2603:10b6:a03:100::20) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|DM4PR10MB5944:EE_
X-MS-Office365-Filtering-Correlation-Id: 843a2fef-bf79-45fc-3bcd-08dae29b1140
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rMy6RjbjsbAk4tcU6vDg8nDD3zmY9AkfkSh3OGUYNR3rSUS9vlyIUVTNfY7t7vI/I1LAep77Mydkxi+0hPq2X0Z4aoCH3tH/yaiAMiISoUpE9RkNXdt/aRk00TkzA05+/eXoeekdYfNv1U7HWQBXAB4p/RdU9gwWzlLQl1pvgDgCIRdrHF0mKbNpgrDgJRCze6GuV2POqalt3znudcSLsy3WVJSSEj8k/JbUGftlfo4bCLppxD1mkxfsGE9+CekszgkYTfr5xmgYkeSLiEqDdwybzRLjynMBcZVzpqdbGSp6bNSJyWzdAws2+Jg5aSoJpVv7faDrq8fodMfc0ozkJuhmsr+17KKZn6uOl7anDo+aXkVIS/y5/H6aWpHC5glXUXtTVuCVCRIsVz1XHu2UT+ZGRWIAnlfQ6jZZmCsb8ijDCvBRHO0o4rWrkOOvSsIJwjo3PRc/eIEPs7WzdJWR47uBADIjGaCaO5/ug/B7WQFpiMv//Hbjc1MRyCTSlY5ewwWdr6exqvsgNh6ZLiT7MM0M4FDQuFuH13DwSD94kpuDmdVcKz28Gzmyeo9nxHwbER1qpNi63gaFV42zy3pkjfDHEvNFq/3dpgnDvSTFCvr35dIhHahDShqDltXf284iO3ARtjGzeN9pSmFyoZF0Z8YMUk6+ricFFBohOJZ2d249rbGbdKlF52ql0MFIrlYFb0y+XQKWCfjJDh8b9/200cLBp1J4biZv/uu6DzOG2e4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199015)(2906002)(44832011)(5660300002)(316002)(110136005)(8936002)(41300700001)(8676002)(66476007)(66556008)(4326008)(66946007)(36756003)(31686004)(6486002)(6666004)(478600001)(53546011)(86362001)(6512007)(31696002)(186003)(36916002)(54906003)(26005)(2616005)(6506007)(38100700002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dThxY2IyTllmeXpMODQ4aUZJVUNzOHg0Rzc0dWNFWkVlM1EvTEdkd2hBRS9Q?=
 =?utf-8?B?VHBmOWVuZFUrSmQ5bStsUlMreXoreWRvZVE0TjlualJvaGFFd3ZuSzgxdTJv?=
 =?utf-8?B?QnhSSVUzODErTzQ0WVU3azAxcFNiRWtUSURxNVN6cGVGOG0rUElrNXhmSm8y?=
 =?utf-8?B?MWFDSklueTdhaWxBMFM0TGMzZUFRNDV3Yko2dTJ5UzkrT1dVdmRKUTFPdStH?=
 =?utf-8?B?Z3VDUUdGb0tFRU1nUVFJSTJtY0JtYm5rV2NKWG5HWm4vOXF4anRHTlJmUmxW?=
 =?utf-8?B?T2FWcHIrdG9HMDRZN3pia1c4c0VhcDNKem9VTnVVbHJlVmM3d1lxNWVWNFky?=
 =?utf-8?B?YXV1MkxDSzZKR1BCb2tTNW82bHYwSkhoOVMxd2NteXBWMit5dHVSVzhoNjR5?=
 =?utf-8?B?QUc2TzRDSmg4MWJsOWx2cnZsajBmUGZCWk9UK2JzY1kxSVA4V0Q0a3NCam5U?=
 =?utf-8?B?aUhRUWtyYnM1VUlpa0NLNi9ING5tRE1sRWowYWRCb3lpRkxIUUdLNFFEejF0?=
 =?utf-8?B?VTdodGtyYks0U053N3VPQ1FZODRYR3VvY2dZQ05aWFdkNnB6Q3hYTnRLcnZq?=
 =?utf-8?B?YzdBR2cxSnFVcXdBOWJqSDBYczJORzhYczM1YXFZa3RJZ1MzMHhaQXlOdDFB?=
 =?utf-8?B?cG9Cdmh0a3IrUUNVanRIdjVOUU9GRmZVWEt3ZWcxTG5lL1Jvak0wTGVVTi9t?=
 =?utf-8?B?b2xXT1lsNFNsNDZ0eFBjaThid2lWRFVEejFweWhPR0tsbVVybGtob2tyeERS?=
 =?utf-8?B?Ym5seHJwWU9vQTJnbTJCb3p4UWZiRjg1MnRuVE9uT3NLUm1tSWxiWkNvcmpi?=
 =?utf-8?B?VytGU0ZOQXhZWk9jdkhnL3ovUG5sYkhiRzc2amI2eEV5UHVqUndxdjZEKzBP?=
 =?utf-8?B?UzdHZnQ2RDFjM1puanRkWlpZd2gzUjMvM0xqdmZnNFpIRE9uSVRCNFdYNmEy?=
 =?utf-8?B?RHBPVmpReWI4OTRTNjhNbGRZYnQ4NWhyK21EMHpxbzFkSDNoWWRQcnhrRWRi?=
 =?utf-8?B?REJNc2tOZklqa2tISEtNTnF3eUtxQllMbUsyOTQydGlsUkFGUlBkbWI3MTZ1?=
 =?utf-8?B?bVVOc0RoaWNwWFBjNTNlSUYrTUIwYXZES0V6UC9MMUpoamJpQ0c5RytQc1Rj?=
 =?utf-8?B?T2VtS3doaTFPV3Q4MllrYjE2MGdMQ25hY0puVlNzNmFrcFVLWmxpTlpNMG5Z?=
 =?utf-8?B?cE11TDZjN0FpQ2wrS0EzMm81Q3JTWEU3aUhQM0N4U1ZodHF0eGU3YmV5OUly?=
 =?utf-8?B?QXZMM2cwNHFKSUQ2ZGRvaU50R3R3NmVLa1ExUlFRTHQ1SXMvbHUwUFVWT1hs?=
 =?utf-8?B?dE1jdUFOaUI3WDZXNXJ4OHNYSjArdm5vTU12MWFMRG02THpIRzgxQ003cTFi?=
 =?utf-8?B?MXdWNUZBdWRsQ3djTCtkaUFTVHlTMTdvS1ZVc05vSk5tS0U3VmVpTDByVy9a?=
 =?utf-8?B?cUN3bm9sSW9vQTB2bjJBVENUZTVsZFFPRjlKbERCYXFvdThDZWpsSVUwcXl2?=
 =?utf-8?B?ek9FZXBEN1R0MlpnOStWdE9yallWV2czZkFXQ0lDajdGS0xFWHo0bkVaVUpl?=
 =?utf-8?B?aXhqZFJ3eGY4Vk1vTU9aQUZJL0MyUDNiMkdKUkEvajR3YVNrcnMrR0lBdndM?=
 =?utf-8?B?dGI0aTVrcFFqMGlhSSt0SGlWR3ZVOFhKNVh5dVg1cXViQUwxd000UTdTZ3FC?=
 =?utf-8?B?SW1yNXlkYXZWSDYwakk5bjAyQUxKRm5GNGFYbUFjKzBkL21pUHpyU3cxaGZ6?=
 =?utf-8?B?WjBEQjdjSVBRTStWMC9yY1NMSXhIUDRublRZRFNzZGZ1L0xqOWxLbUZnSG81?=
 =?utf-8?B?Q3RDbVd3L09CVkFIU0R5RFZBaitoUzR4OExkV0o0WFQxUE5BakRWakxYcHoy?=
 =?utf-8?B?NWZkb0srNnZNckx2c09JeXZhSjlHcG5ha0tPMEI5V205SkUzYkpsaGtQSVNJ?=
 =?utf-8?B?Q0g1T1ZPN2pNK2lyOXdkUTJBRUVGZkZEdU1kZUZPelF2ZmU2dFhlK1FDYmFq?=
 =?utf-8?B?aHRlT3pxTTJ5WkZXY1g3UmhlN2xXS2RJL1Y4N3ZBLy9rblRvSVJ3bEduWFJ4?=
 =?utf-8?B?NUVaM1ZkSFdmamNPd01QdFhDcHozVW1OK0ZLMHdmWEhEdWU4Y1lIMU4zZmdh?=
 =?utf-8?B?OUtOUUs1K0x6cnJxVUl6S3I5T1d3ZzA2ZmoxOTRtYWtMRDR2VjlXQmhYOFNL?=
 =?utf-8?B?UGc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 843a2fef-bf79-45fc-3bcd-08dae29b1140
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2022 15:01:26.5139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ro4EZW5ra3h1ecxWte/Wo3R7xqs+yNpfHE0X68/sp1aCQMaZnUnkdo1bONJFE7t1ThWyE1m5w7LkPiMpTTtBpP8zeGX/RDHqeY0pPD1V/wk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5944
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_05,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212200124
X-Proofpoint-GUID: aOISuAqcPj6TBRcu2L985E7uAMw9ncSc
X-Proofpoint-ORIG-GUID: aOISuAqcPj6TBRcu2L985E7uAMw9ncSc
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/19/2022 2:48 AM, Tian, Kevin wrote:
>> From: Steve Sistare <steven.sistare@oracle.com>
>> Sent: Saturday, December 17, 2022 2:51 AM
>>
>> When a vfio container is preserved across exec, the task does not change,
>> but it gets a new mm with locked_vm=0.  If the user later unmaps a dma
>> mapping, locked_vm underflows to a large unsigned value, and a subsequent
>> dma map request fails with ENOMEM in __account_locked_vm.
>>
>> To avoid underflow, grab and save the mm at the time a dma is mapped.
>> Use that mm when adjusting locked_vm, rather than re-acquiring the saved
>> task's mm, which may have changed.  If the saved mm is dead, do nothing.
> 
> worth clarifying that locked_vm of the new mm is still not fixed.

Will do.

>> @@ -1664,15 +1666,7 @@ static int vfio_dma_do_map(struct vfio_iommu
>> *iommu,
>>  	 * against the locked memory limit and we need to be able to do both
>>  	 * outside of this call path as pinning can be asynchronous via the
>>  	 * external interfaces for mdev devices.  RLIMIT_MEMLOCK requires
>> a
>> -	 * task_struct and VM locked pages requires an mm_struct, however
>> -	 * holding an indefinite mm reference is not recommended,
>> therefore we
>> -	 * only hold a reference to a task.  We could hold a reference to
>> -	 * current, however QEMU uses this call path through vCPU threads,
>> -	 * which can be killed resulting in a NULL mm and failure in the
>> unmap
>> -	 * path when called via a different thread.  Avoid this problem by
>> -	 * using the group_leader as threads within the same group require
>> -	 * both CLONE_THREAD and CLONE_VM and will therefore use the
>> same
>> -	 * mm_struct.
>> +	 * task_struct and VM locked pages requires an mm_struct.
> 
> IMHO the rationale why choosing group_leader still applies...

I don't see why it still applies.  With the new code, we may save a reference 
to current or current->group_leader, without error.  "NULL mm and failure in the 
unmap path" will not happen with mmgrab.  task->signal->rlimit is shared, so it 
does not matter which task we use, or whether the task is dead, as long as 
one of the tasks lives, which is guaranteed by the mmget_not_zero() guard.  Am
I missing something?

I kept current->group_leader for ease of debugging, so that all dma's are owned 
by the same task.

- Steve

> otherwise this looks good to me:
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
