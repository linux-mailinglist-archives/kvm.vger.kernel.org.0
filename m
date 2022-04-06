Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5E84F635D
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 17:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235822AbiDFPVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 11:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235842AbiDFPVO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 11:21:14 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673F253E7EB
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 05:32:43 -0700 (PDT)
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2368kWeC024567;
        Wed, 6 Apr 2022 05:32:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=8ANrguLKqfkLg26VSY8oogvxLypL/TrhyN0afsEtATc=;
 b=0YhGPskPlKHSQAmEO4mxM6bt5G2EtEJUoqTfJwi3A2VhHRo5Ix2Sc5FgFUVEnsdp6FR9
 sJ9MjfBTaCnERZQZq1y2lXJWIQzW7UUp6MiKzgdS/ga4OOWdGK0CCii1Ct366bN5tO0w
 7juFGo9yhBfP+EvdVN3GXVmJjbw5fKgTYuAYATAn2dSU9EvG1EPNncfUsgRmrKk0Z573
 igZpjASSEQ1A+pI8b/iEkNT3LB3mdtZqY0vbmEQKQIhx54ux6rTRc1bvwvg4PwkJenAN
 FsfRArwhPkqlAWVofTYXuBG+zBbMeKBLnwmbwkPhEHwOgRfpvedmsUnLx0IecOPXI2/G kA== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3f6p1ygbgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Apr 2022 05:32:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HymiuLiVJPfVHn8+pfMCmSvPxHWn8lTH8HPaaVmAUbFqz0yrbfgPR44PFOVPNRV8CldkDW5e0yMEDZ3PN/zRJKz7G6T2NXZwv8cp8pgeL4kgGBDgqifiguOtLEMuS5SaWctnB7nQ4a5+Zn1N/M+feTxsAAwF4+h7uN7Xhu6sXOlhwcpymKYvx2N5QxqykyZhZXcCiTST3Z4KXGZd3QG+rqpEWZMnHUY/AIX48ia4xVxS1QjLFWWNLY3IWLzpCgCqY13IC1AzL3b+bOpRZwHXCOVWCj45g1bEigy8mdEuTb5CXaXvqdWx1I/C6oYq7C/KTy+cFkudS7mHYzu/oQXdvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ANrguLKqfkLg26VSY8oogvxLypL/TrhyN0afsEtATc=;
 b=IOfF7O+SrdtTxGlt1ssPtriH+jE+AJhPEdmj2I72Rjra8MkrNvD+4xTAKifIeflXkkzZyQJeBfI6W35pk3niwZSuAHZMTIy4m9nUsYJHnKBSCMrZIxTSo6QVVVgaePtH0F0pLaDyou4r29XADNSKM0nF6L84/nbUUqxY+QygfUB6v/lzKF5gqNS5Fx6OHjH2blFCRMWd+W8sLMlMzrYVcsh9FydqvzKHdIdhreysc9Z8nOWhoxUNnwgsq7TBW4dt0OYeoqox/J8s31qxYz5LTxdXuqeIkHay5iUVYNgVsP4EA0RqdWWRdfUOIlkBr9yO+zYlEWi3FHMH7KbV1jLw3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by BYAPR02MB4933.namprd02.prod.outlook.com (2603:10b6:a03:44::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Wed, 6 Apr
 2022 12:32:37 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::f8cc:e0f5:bc13:d80a]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::f8cc:e0f5:bc13:d80a%7]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 12:32:37 +0000
Message-ID: <9a34bdeb-fe49-b8be-0907-1bbc57964b5d@nutanix.com>
Date:   Wed, 6 Apr 2022 18:02:25 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v3 1/3] KVM: Implement dirty quota-based throttling of
 vcpus
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
 <20220306220849.215358-2-shivam.kumar1@nutanix.com>
 <YkT1kzWidaRFdQQh@google.com>
 <72d72639-bd81-e957-9a7b-aecd2e855b66@nutanix.com>
 <YkXKtC8PCfIUMs8D@google.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <YkXKtC8PCfIUMs8D@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR0101CA0071.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::33) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90d15fc5-a4c7-4b9a-0ca0-08da17c98836
X-MS-TrafficTypeDiagnostic: BYAPR02MB4933:EE_
X-Microsoft-Antispam-PRVS: <BYAPR02MB49337BE7727E3399444D6905B3E79@BYAPR02MB4933.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dbd8S/IXWIH854TLd7pKZ50FNtBiMyDzHe9nX2kPuRaoStFRzFIXLIUpzDyuWVYDGzUOOpTAVcy7vo/3lkrqLxqoZ8PUtaKSDX87+Om1bDYSBPAf+43zFgQ4+Y3/b2TJM3wpteMBYKiAxR/veEaqrq6kETjr6fYLpsmEMv8ZM0/E7MH4DfnZOxEYPZNSdOP2su31IbOZNQXLg3qPPeMYQrcu4rVc9pUTGuzpUK/n2O2wpdt5R/MDDC3zZTTew7v8KbiBT/pg19ywiWhbyWkTcr5upJUi/8KjJ5dtCjrE5FxXSN3ixQEsIHCsURgqCOHWKXyhXhpBho/ufcO/nK+5YqrxNpaRLFLEyVUSb2UfT17fInNyQzOloMf03kX3OpjUbRAdTdqbYn+jJ8KTpsOTCEqlbRUrRRBk2tiV1Cdq4oqO6tppWV2MozeVG+raLlSZ0IpEAPP4fxd/7Jn+INGO1RfJOSmFlp3q+ciA0t75kIyNi8rfGdsZxrlQIUVqYycZeGUriXwVLt5Qn0jmxytCbK8gNcp8XpyAMuM08rE6wUoTHkoYrGWAvmo4RQ7GIBdGC7nJ4ciopfJnymyXTwYh0tl8X3AMSPyXAAsnYT4Sq2Rk6mzTOXIgnJLWYNFuaX+w+0W6GIbwictDIWlKU7CnKp6pOmnrh+IDQB5bHTq4XNlB2GROyMxePl+4O0u0Z7QdDKykaowrPpGugWIDy1hPL+ZOQBPyAjlUHw6zPlMV5wOfdpiaqOcS/I3rBxnNs3ym
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(54906003)(6666004)(6916009)(6486002)(508600001)(36756003)(31686004)(86362001)(38100700002)(31696002)(83380400001)(2616005)(186003)(26005)(6506007)(53546011)(6512007)(2906002)(15650500001)(5660300002)(66946007)(66476007)(4326008)(8936002)(107886003)(66556008)(8676002)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2pMbHA3YzF0dytjcnJUM3c5bmU1ZlFOUUJ1K1FSVjVkRFR0K0lZMWZDYzFM?=
 =?utf-8?B?T2E1NVdkU0JteXlUdVBrOEJxeGVnWmwvRVZjSzNTS1R3Q3g3N1hpeDhYRmdM?=
 =?utf-8?B?clpqVDNJZ3FabnJreFAwcFQrQlVWbzdaMjlHMzRIZWVLYkFLRUZPODRZNnpV?=
 =?utf-8?B?NXdoSG5aRDM2cVh3Qi9qaFovOWY1dzlCdGh2cGExbVlhVGVHTHV2VmJOY2Zu?=
 =?utf-8?B?b0xCdmlhd082bkQzeDBodUc1bXY0WDFDelhuSDlrTU54OEo4ejN2SVdtVCtF?=
 =?utf-8?B?NUVER2hrUjlSdkZ5NlhpSWZTN2ZhZEVwdnZ0dXJSZWtTYWtYa3d4Q2psL2RF?=
 =?utf-8?B?VExrWkZRV1Naem9ZVmdrMDJoaFc1WFJ3M09zV2hzQm5YaTYvYWd6T2x1VUps?=
 =?utf-8?B?SmcyRWhIVzBONUI3M0VWekQzK0VWWW8vQUlTS3lCYmNtNVU5TGdIV0ZJMDNX?=
 =?utf-8?B?dS91RnM0SHF1OEtjcnpCT05UbndCeDJFY1BJV2cvMW5pWVJCV09POGU2WmxZ?=
 =?utf-8?B?SWs5cXVzVGJ5dThvd1dISUVyc2lubmN3aFpvZlZBNkQyL09uK3dFWXlQMkFN?=
 =?utf-8?B?SFdkU1IvOXBvWWU0TGVPczBNWk9mOGtlY3czdkxkQ1BjSzZBbVFXZVJFb081?=
 =?utf-8?B?eExZc0tNN1ZMdUd5bTVKS2ZGSnRScUZHY2VOU1hWTHI4VmtJKzVUUlVWV21H?=
 =?utf-8?B?UmlSWXFZSEdNMmFLaUMyRVVWdmpGYXdtd2JMeVk1MG1xZXFYSVo5akIyQTFq?=
 =?utf-8?B?TnZmd1pKeVpCMHRHSFpjNVU3QU55Slh1YUtzVndXUGlSZ3J1Tm1GS3QrQUJt?=
 =?utf-8?B?dCtFUngzOXhEdGxydUo4OE4vOTNLVEZOMS95VzJKbEF5TzdOVnpDME1jaUlX?=
 =?utf-8?B?eTlCemo3R2NESHF0SXNTMXMramRNNVMrcXVPODZvRlp5TGswNlJRK3BTMjc3?=
 =?utf-8?B?SUl5SnRUU1A4TWhhSERvNEw0OEpOTVZZMWRqZW9JeTJRL0RyOFlPR2t4RDlJ?=
 =?utf-8?B?V1RidmRwQjZ4MW5OMzNkczRMeVpuWjBQYnR2bkxqZUVjb1NVTkJRUXRVcmF4?=
 =?utf-8?B?R2o3bGZtazJWOVdMMklXSUg3Y1pmS1FXR014b0htcjlFcGdLUERyRVd1bXNz?=
 =?utf-8?B?M2IvU09TeUhTakJoekdScjdBa1F4RGx1MGJWcFM2ajZyTkYzQkIyUE80WUt0?=
 =?utf-8?B?UDB2YzRTZkZXZVppUmx6UThDNEZOdVpVMzUvRFZBZXJyS3QzNU4xM0Nmdmlk?=
 =?utf-8?B?L1J4VitNWk5KdVpzbExGdUoxQnp1d3FHdXF1NUovZy9vQ3lVd3ZFV0dlTUFu?=
 =?utf-8?B?WnJ2OHFycVZ2SUVVRVJNNTRuQ3RVWDJYKzc5ZHhTd01GeVFjRlptbFJwaklW?=
 =?utf-8?B?eVpVbUU5c2VmcHZ5Q3plMmh5bTlhRFc5R0ZkTDVUa2FVT0FEU2hqalRvQVVi?=
 =?utf-8?B?K0VmSHF6Y0xQdW9EM2dPd0ZwalNrMVV3S014VHd0V1J2a3pWcnR0YnBZaVNi?=
 =?utf-8?B?M0JIc3RQTEJMb0xpNGwvVFIyVHpkR0pvY0N2ZWZ3ZlZrakRycTNBajg3eUdH?=
 =?utf-8?B?VDUydmk2RVJjdUlmV0VqYWN5WTJ0NkcyNHFVOWlDSks5bkgrNy83Yzl2VFVB?=
 =?utf-8?B?NUJTTm1xT3VZUUJIVUpIYnZvTGlQdW11NXg3cDVGTXNJOFNMc2VMVGJ2ZDJ3?=
 =?utf-8?B?eU1HcXJnUE9qSTVETW5tZTJuSWF0aVJ4bjF2c0lEN3FzOG90MWg0eE1NV1pR?=
 =?utf-8?B?WlY2ZTl4TjhlWVF2TjBFZHVBSnJFM0dBQzNwc0FZZmZBYi92Y21yclpEUUpR?=
 =?utf-8?B?dlU0SHpKKzJWVk96RlhndkhjdngxUEhBbjVqREYzeTc0YTk4R0puYUJXeVpr?=
 =?utf-8?B?SXVkR0xEbjRObWpRZ0thQkdUM2pNS2JvNmJwYWhzTUJlTVNmek9mRG1yOUFP?=
 =?utf-8?B?NjF0NmN1YitzRVExOGYzUmhHNXJYVDRwclNEZXhaYzJ5eThUMlJLWjM1Z25J?=
 =?utf-8?B?dTZGTFpmRUgwSWVJdUJZYmRjdXlrbGtYSVl2bEVKOUNiMlJjQ1NPU1R3aVQ5?=
 =?utf-8?B?Q2ZKVmY5MDRRZ2VpMjJlRlJrU1JQemZab0s2dm53WGo4QWk5YjBVVlJQRDFj?=
 =?utf-8?B?MXh5Y3h4Y2RncGg3QzdkQmxYTk5HUXlOZldROUJudVo2VGg3dXFKUUJwdkd3?=
 =?utf-8?B?bngrYzAvVFNZbDFsU0dNY2h1WmtGa1ZReGlEL0U1aGM0NWQxSWNZUllJNTF3?=
 =?utf-8?B?cjJUUWRzQUZ5M01WcndRN2lzcHkrV2dFdjIwTFJyMVdFY3huZE43R2hnb2Jr?=
 =?utf-8?B?ZWVUVzB1bHFLYTZZaTBFTExyVmh0YlBjZC84Ry9CMmZVakZTL2E4bU5NR3F4?=
 =?utf-8?Q?jayGOE8E5+ypEdRQ=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90d15fc5-a4c7-4b9a-0ca0-08da17c98836
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 12:32:37.0904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9p5p4VP1lNTbLlMDT7K8rfk8l8KI/fn0r8O2LTcHARScMnHvOJkixjC7LO02lj6dRpEDB4LgALOpSz3UfJdr6dJWJiAhTh2zZuZNBdLK1+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4933
X-Proofpoint-ORIG-GUID: zjngXY8u0_nt8OGUYiPYoeaI3EPm0Efc
X-Proofpoint-GUID: zjngXY8u0_nt8OGUYiPYoeaI3EPm0Efc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_04,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 31/03/22 9:07 pm, Sean Christopherson wrote:
> On Thu, Mar 31, 2022, Shivam Kumar wrote:
>>>> +	if (!dirty_quota || (pages_dirtied < dirty_quota))
>>>> +		return 1;
>>> I don't love returning 0/1 from a function that suggests it returns a bool, but
>>> I do agree it's better than actually returning a bool.  I also don't have a better
>>> name, so I'm just whining in the hope that Paolo or someone else has an idea :-)
>> I've seen plenty of check functions returning 0/1 but please do let me know
>> if there's a convention to use a bool in such scenarios.
> The preferred style for KVM is to return a bool for helpers that are obviously
> testing something, e.g. functions with names is "is_valid", "check_request", etc...
> But we also very strongly prefer not returning bools from functions that have
> side effects or can fail, i.e. don't use a bool to indicate success.
>
> KVM has a third, gross use case of 0/1, where 0 means "exit to userspace" and 1
> means "re-enter the guest".  Unfortunately, it's so ubiquitous that replacing it
> with a proper enum is all but guaranteed to introduce bugs, and the 0/1 behavior
> allows KVM to do things liek "if (!some_function())".
>
> This helper falls into this last category of KVM's special 0/1 handling.  The
> reason I don't love the name is the "check" part, which also puts it into "this
> is a check helper".  But returning a bool would be even worse because the helper
> does more than just check the quota, it also fills in the exit reason.
Does kvm_vcpu_exit_on_dirty_quota_reached make sense? We will invert the 
output: 1 will mean "exit to userspace" and 0 will mean "re-enter the 
guest". This is verbose but this is the best I could think of.
