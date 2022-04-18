Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199EE504C11
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 06:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiDRE6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 00:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbiDRE6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 00:58:33 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45229FD5
        for <kvm@vger.kernel.org>; Sun, 17 Apr 2022 21:55:55 -0700 (PDT)
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23I4UJQT007418;
        Sun, 17 Apr 2022 21:55:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=i7HFaaXnsyaYlWH5et6Bn5fmeStlzCUC6UmveubixY0=;
 b=11JgwqbRvyAPqlJEWF1tHSHaiuotInLDpByjTQ1AwzkLHpbooMqM4U4tNdrpvle3x52W
 +bhAOnxxJW8C+PNPnMKu18Le7s3PM/bzUENjo4zaxEBn8HJXxj0nSJa4IwwaZf6wutRe
 F8v+z1oawy46aBTnxYDOznoxCjmMHYhQXqmfN4pFwvIQCfIUHvjYLuYOS+JgUIk08eLe
 6OsCx0EtP/zkqKOxx/NgEQ/rumQGMtNBfiTV4tL5Mn7U3uYYx69s7KASq4A1gB/Le7Rr
 DqJNBi/e3uJWdxRgrzjIQdHEjaZF+nS7GCURUezh0h9s8Nu2NWCsPJV6ELzCOL6mDnQD BQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3ffubajdrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 17 Apr 2022 21:55:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LCXYSXAhbV4u/uhuTz4XBlQ8VhXbHlmZBOcSQiCLe7oy6/C5UsaY66SbCFAcD2ibkqi37fqrb9n0zA301dRrl9ca/Ybh3QEOLF0OcPb0rW+dnkGNe6sxSI/4wJuJ36MdC3N2dP7hVqycQV0DtB3TLwSedQVUcs3UpURoT4R31uJBbtVufFAE1WkdQHZKiaL+ia7l5jz0tugDc/sSvMjUSoIvukO0E/CY0ou4twJIJB6A3dd1YEraF50AKoBvbe8T/9HLs0auDCHNTwVXyqKzHHYMsytbpTsBMPQnO1q8TZlhX2tUKDZgVmqWNAJibxZi2P/OafQDnMyLxcMdbUo3kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i7HFaaXnsyaYlWH5et6Bn5fmeStlzCUC6UmveubixY0=;
 b=irFkGgnrtBArO6YR5k4hYqhXdGLI7Jb3bzXHA99qFsIhvG8676tDbr/TMV/pFIr1/+FMFgmvvPWWyod/UV87usvRgaPXSNhFVIoEcN1ddl0w0aB+wXTyEwdI/HutI4JFvzWhOiQlofO68NaZIUDbGmyZhi4S+VVkrMm5s+1rZM9E2Eg2mJ4Mlx8Rvic15HSEdt026MVtXog/C0x7mJBNfAKo/ycWwbONhmnF3DDjXDB6BLto6deOsko/GQ2pQFwC0D2gPgBDFDihfxhIAwsoJJFLe67Gb+jkHmizl9ek6zM/LFRS4C6O7X7NwvWiBt7CCsOaF41DrTETtRB+aHjS4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by BN0PR02MB8255.namprd02.prod.outlook.com (2603:10b6:408:156::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Mon, 18 Apr
 2022 04:55:48 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::d9e1:228f:6385:a107]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::d9e1:228f:6385:a107%6]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 04:55:47 +0000
Message-ID: <3bd9825e-311f-1d33-08d4-04f3d22f9239@nutanix.com>
Date:   Mon, 18 Apr 2022 10:25:37 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH v3 3/3] KVM: selftests: Add selftests for dirty quota
 throttling
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
 <20220306220849.215358-4-shivam.kumar1@nutanix.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <20220306220849.215358-4-shivam.kumar1@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR0101CA0024.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::34) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4603e70-8a7c-42f7-1de3-08da20f7b3e1
X-MS-TrafficTypeDiagnostic: BN0PR02MB8255:EE_
X-Microsoft-Antispam-PRVS: <BN0PR02MB82559891065B56B52BA413A6B3F39@BN0PR02MB8255.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /fEA/L7ZciUwoUaoUJKCtecIefan8eC4UtBM2VrOuIy2lxcTr6XvlRc24m8d7tCvYbjHEHPFv56VHdqFg5r0Q7cafsWi//DihohoLPN7KE4Zw66R7RLds0bAQcVI0571YwwZuuVn9ovbyY18mxnSej5kwRJkNH7AKDdCmCfECTVDOrpY85NKll0sncsgRPLy4qjXWs1S/JlpknwLuB+wSLek2fNazUzfGmNCCcRRKKclR1FyIBXMAGdJZPM1n24uJ+to7oEVTVjqzqjwrmC6624uBuHA5nVsuPLBK6bMetog9NIXPM+BmXcdgqDJjyHkpKdSRML/fnma4Sj5e8BPdJJEdU92l2YKKzWjt014FwyIdCNHI2lUdVQ1xSaQwDfg0bwd6GaowEzMtmKzNhnFnwgnU6mIcts6AoOgwOuhOTIIZQTb230q+JZWK/mftFLDXut4N8o3PRd+iAS8t5VTK5p5DC1ij1U/BYkNTPW4jf5qPFW5iDSOX/eRXBnOi1JNXqXRAoWhGW+TFYjH5y4fmoSBl6oenoro6pKHE8L113mjeKR/cBvfrZLhUEJ4P7OjFuAUHtLf1kKdeX3r2wDXNynn2Y5Qg/AxaGbT0oEOi8Pzblx7glVdoJrBRREGJRXMIGl8JLx0rtuh5sElHZejz/YpXux6yI8HRiyt7PH118tlqHviVZmiBxeGTusgfcXjeD6yysPp74PGkOKx6b7yAAUW/ACzzsTpfAEcZUSOquyLmlMDz0VCkrdxixfr8rcMmwSuGOUMFnRddeBY6hGJdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(36756003)(5660300002)(66476007)(66946007)(6512007)(38100700002)(66556008)(316002)(55236004)(53546011)(6506007)(54906003)(6666004)(508600001)(6486002)(45080400002)(2616005)(31686004)(15650500001)(2906002)(31696002)(186003)(86362001)(107886003)(26005)(4326008)(8676002)(83380400001)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUtTVjlseDlLQm8xa0hkOUNEK1VYU3VFeVB2cHYyb0NhWWJscUdhYTFiaWhQ?=
 =?utf-8?B?empjSURKZnRiVmp1VDNDRnI1dWhmZ3pLTWhvOEczeUdWS0ZMRTVRb0pmRVNp?=
 =?utf-8?B?RERlY21Na2Y3L2VzSlNsZlFQazkvd3ExQ1lUYTJxYmVWWUFweWlnVWlBMW83?=
 =?utf-8?B?NEdyRUFzdDdWYjZMcTBlcWo3bVlmRUVCNC9NdGJRNXNoN0xCY1ZHZHNlcHNS?=
 =?utf-8?B?VThuZkVnWXhyNVhTb2RoV1JCSldLa29HSXl2UHFQbEs3cXVKOGlmdDJUS25s?=
 =?utf-8?B?YU43QXA4dXg0cDd6THBJTDlOSHFMTDVBYW0yTGlqcWhnNHJzTS9YUFptRjhG?=
 =?utf-8?B?Nmtiak1nVFJmYUFpQXlqU2tJTUlIdVFUL3VIdXpoNVpReHY3c25VeTBlUDFQ?=
 =?utf-8?B?TGliU2w2bDcwdlg5ZVI5dnRTalhMbUViTEtFOVQzOXFhUHhFM0owcmoyNGNk?=
 =?utf-8?B?NFlMTUFha044a0JxR0YvaFRpRWZjQW5xQkZIcWhtTG83TWJIREFteGxtK0pB?=
 =?utf-8?B?VDhpeXhLaTE0YzgwcW5GY3RybTBWZGFjcHRVbmkvUHVzRVFtM2s1TVFHWVZQ?=
 =?utf-8?B?Y3ZETXJHU0tqcmlOaG8rQUpTOUx5Tm14c09JRXM4dFRuVENWRHhhWXM5MVRx?=
 =?utf-8?B?RzlBamZhRGtYZlpTOFhmT0xid09JQVBpMGV4WTRhRVlSTmFlci9uYzM1eTZB?=
 =?utf-8?B?Z3BPMlhyRnY2blR6OVdlLzVCaDl1Z1Q3WjNweElOSTMzUTk4OVhBUDNSQ3ZS?=
 =?utf-8?B?b0JBSHdUQ05ON3dlS2RrKzhxdmQwVzE3S204Q0VwUlNxMFllWXVlSnJxRHBW?=
 =?utf-8?B?eVZHeS9QTWZOUG5hNWQ1a2VHYmp1L09NeGhtL25ucHB3VVRwSml2UFRoZkQz?=
 =?utf-8?B?cWJKbUwxejAxeU5KM3JvSTFqcDNDa3FuS2Qxb1dDcEFxMWROSjJQdC81aG5v?=
 =?utf-8?B?ZUNIbm5vRFlmYU9pMWd3SFZ0cC80MDFLclJmZ0V5TlR4cGdRc0tkWnZKUVli?=
 =?utf-8?B?QklmUUpOSExXU3hXamN5K3lBMWNPY3lwcnNFY3FrbEJCcnlOYzk4Tjh3d05O?=
 =?utf-8?B?bElvVHIrMjhnaktkOGZMRnRtVXlEcVVlSE5BM0ZtMUtSRlphaWlaYnZJL05n?=
 =?utf-8?B?UFZsY0pjWHRrZ2gyZGprQmc0WGYzc3ZKc0YySENVNWNQWFl0WTZlazZBRVQr?=
 =?utf-8?B?UkFqTmU3YTJBQ2tVRENZZlRTZzJEQXBORlY3cHMycWNOcnkwaUVRZFVsdHVk?=
 =?utf-8?B?eXQ5ZnJOSDdURzRaVVVmUWhuYll6VVZiU0FXbnJINFdua1JCRzR2RXZaVTBk?=
 =?utf-8?B?NWx0c3RqNVVRTTE2ZHl1U2hDTEJJOVFFUm1OMFdsT0EzVmZEcDR1eFVNL241?=
 =?utf-8?B?Z0RsSVQzSmE2T01ZUVFyNjBOb1VQeEQzblF2enNRSXBMMTQzeGdnK25paHp4?=
 =?utf-8?B?bDcwbGp3M2w2SFp0bGFEN1Fuei8zUEpPZStDcEhOZjVPMlFSN1hXZkY3Ujc4?=
 =?utf-8?B?dUxoYXMyZTM4RjRiU04wVzJwSVpYdEJnc2lGaWNSblBUM0NWNHp5b3Rzc0tB?=
 =?utf-8?B?OXlPUXNaMHFDazEwSmRLYjk3Yi9rcjZDaks5SFdmeUZ0blk5ZGREODFyckhM?=
 =?utf-8?B?SGVvcDVPOEx2N3VUWkE4T3JNZXRGSGlKV3BNOXM0Mmg2UEYwUEgxRmE3Vktt?=
 =?utf-8?B?bGRpZnBFMkR3NGxjWCtwS1didExXanpsM2xwL0c2dWI4eDYzTUFaQi9mYXFR?=
 =?utf-8?B?cGd2aGFubCtYNFFVbnYzUlpvSlM5Q21QZ0NCbzh4Uy92SkVKTVpEOGpPZlBl?=
 =?utf-8?B?MFVzSzlLVjdERzZQejRZU3FobHNna29hK2dVNW1NQVpEbUpSMmhjcFdZOGZO?=
 =?utf-8?B?clJGTE8yd2src2phTzdBWXFsWW5lMXVNc0E2bmRpRDUyMU05cDFHWENJVlN3?=
 =?utf-8?B?YUhrNXk3NzRWRlVoSy8rb0ZoOXN5VlZRMEJ5anU0RzU0OG1SYmIzY1c2UEU2?=
 =?utf-8?B?cmVLTlJpaFp1VExzZWxhaHNqb1hiK3cvQW1KZzl2YWk0aStPV2lMZVBPVnlt?=
 =?utf-8?B?aHFTOTdyM2h3VGZ4M2R5ckZEY29yM0ZDaFNzTnFFTmtCMHZNbXFFakpVWkJr?=
 =?utf-8?B?SXA3NmhydjZBY0ZJOHlhV21FS2xjS245YUM1WDNES3F0RHNWd3BTaVU2R1U2?=
 =?utf-8?B?aGlDSzQ5ekpndzB0YndsdC9HTjd6VnZHTUNXS2ZjUlFVYTI1eEpXeGt6MG03?=
 =?utf-8?B?YzRIVk9MVlNtenRGSUt2eTFtdElraVRJWmlKS25TZlhISlRjczRaZXpod2V2?=
 =?utf-8?B?TkhoS2Z2NTJCWk1OTm8zK2VHNkpVc2JudGpwSjhoWGFKZ05kWER3emRqamxp?=
 =?utf-8?Q?9Q54bHhofb6pXX3Q=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4603e70-8a7c-42f7-1de3-08da20f7b3e1
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 04:55:47.5419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VtrteMxW3XdiEkKszgYXmizxsvaoM0Gpqd3UbZgmpqHMdcpszxI1NA8FR8bzjdPDzAW/V/domfJMMGxKxWI3+v4vOXoWLRWk3Xr/k8jWmlk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR02MB8255
X-Proofpoint-GUID: R4c0Oh53P3KRESsEKdABDzfyjE5_W31E
X-Proofpoint-ORIG-GUID: R4c0Oh53P3KRESsEKdABDzfyjE5_W31E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_02,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 07/03/22 3:38 am, Shivam Kumar wrote:
> Add selftests for dirty quota throttling with an optional -d parameter
> to configure by what value dirty quota should be incremented after
> each dirty quota exit. With very small intervals, a smaller value of
> dirty quota can ensure that the dirty quota exit code is tested. A zero
> value disables dirty quota throttling and thus dirty logging, without
> dirty quota throttling, can be tested.
>
> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
> ---
>   tools/testing/selftests/kvm/dirty_log_test.c  | 37 +++++++++++++++++--
>   .../selftests/kvm/include/kvm_util_base.h     |  4 ++
>   tools/testing/selftests/kvm/lib/kvm_util.c    | 36 ++++++++++++++++++
>   3 files changed, 73 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 3fcd89e195c7..e75d826e21fb 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -65,6 +65,8 @@
>   
>   #define SIG_IPI SIGUSR1
>   
> +#define TEST_DIRTY_QUOTA_INCREMENT		8
> +
>   /*
>    * Guest/Host shared variables. Ensure addr_gva2hva() and/or
>    * sync_global_to/from_guest() are used when accessing from
> @@ -191,6 +193,7 @@ static enum log_mode_t host_log_mode_option = LOG_MODE_ALL;
>   static enum log_mode_t host_log_mode;
>   static pthread_t vcpu_thread;
>   static uint32_t test_dirty_ring_count = TEST_DIRTY_RING_COUNT;
> +static uint64_t test_dirty_quota_increment = TEST_DIRTY_QUOTA_INCREMENT;
>   
>   static void vcpu_kick(void)
>   {
> @@ -210,6 +213,13 @@ static void sem_wait_until(sem_t *sem)
>   	while (ret == -1 && errno == EINTR);
>   }
>   
> +static void set_dirty_quota(struct kvm_vm *vm, uint64_t dirty_quota)
> +{
> +	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
> +
> +	vcpu_set_dirty_quota(run, dirty_quota);
> +}
> +
>   static bool clear_log_supported(void)
>   {
>   	return kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
> @@ -260,9 +270,13 @@ static void default_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
>   	TEST_ASSERT(ret == 0 || (ret == -1 && err == EINTR),
>   		    "vcpu run failed: errno=%d", err);
>   
> -	TEST_ASSERT(get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC,
> -		    "Invalid guest sync status: exit_reason=%s\n",
> -		    exit_reason_str(run->exit_reason));
> +	if (test_dirty_quota_increment &&
> +		run->exit_reason == KVM_EXIT_DIRTY_QUOTA_EXHAUSTED)
> +		vcpu_handle_dirty_quota_exit(run, test_dirty_quota_increment);
> +	else
> +		TEST_ASSERT(get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC,
> +			"Invalid guest sync status: exit_reason=%s\n",
> +			exit_reason_str(run->exit_reason));
>   
>   	vcpu_handle_sync_stop();
>   }
> @@ -377,6 +391,9 @@ static void dirty_ring_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
>   	if (get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC) {
>   		/* We should allow this to continue */
>   		;
> +	} else if (test_dirty_quota_increment &&
> +		run->exit_reason == KVM_EXIT_DIRTY_QUOTA_EXHAUSTED) {
> +		vcpu_handle_dirty_quota_exit(run, test_dirty_quota_increment);
>   	} else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL ||
>   		   (ret == -1 && err == EINTR)) {
>   		/* Update the flag first before pause */
> @@ -773,6 +790,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   	sync_global_to_guest(vm, guest_test_virt_mem);
>   	sync_global_to_guest(vm, guest_num_pages);
>   
> +	/* Initialise dirty quota */
> +	if (test_dirty_quota_increment)
> +		set_dirty_quota(vm, test_dirty_quota_increment);
> +
>   	/* Start the iterations */
>   	iteration = 1;
>   	sync_global_to_guest(vm, iteration);
> @@ -814,6 +835,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   	/* Tell the vcpu thread to quit */
>   	host_quit = true;
>   	log_mode_before_vcpu_join();
> +	/* Terminate dirty quota throttling */
> +	if (test_dirty_quota_increment)
> +		set_dirty_quota(vm, 0);
>   	pthread_join(vcpu_thread, NULL);
>   
>   	pr_info("Total bits checked: dirty (%"PRIu64"), clear (%"PRIu64"), "
> @@ -835,6 +859,8 @@ static void help(char *name)
>   	printf(" -c: specify dirty ring size, in number of entries\n");
>   	printf("     (only useful for dirty-ring test; default: %"PRIu32")\n",
>   	       TEST_DIRTY_RING_COUNT);
> +	printf(" -q: specify incemental dirty quota (default: %"PRIu32")\n",
> +	       TEST_DIRTY_QUOTA_INCREMENT);
>   	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
>   	       TEST_HOST_LOOP_N);
>   	printf(" -I: specify interval in ms (default: %"PRIu64" ms)\n",
> @@ -863,11 +889,14 @@ int main(int argc, char *argv[])
>   
>   	guest_modes_append_default();
>   
> -	while ((opt = getopt(argc, argv, "c:hi:I:p:m:M:")) != -1) {
> +	while ((opt = getopt(argc, argv, "c:q:hi:I:p:m:M:")) != -1) {
>   		switch (opt) {
>   		case 'c':
>   			test_dirty_ring_count = strtol(optarg, NULL, 10);
>   			break;
> +		case 'q':
> +			test_dirty_quota_increment = strtol(optarg, NULL, 10);
> +			break;
>   		case 'i':
>   			p.iterations = strtol(optarg, NULL, 10);
>   			break;
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 4ed6aa049a91..b70732998329 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -395,4 +395,8 @@ int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
>   
>   uint32_t guest_get_vcpuid(void);
>   
> +void vcpu_set_dirty_quota(struct kvm_run *run, uint64_t dirty_quota);
> +void vcpu_handle_dirty_quota_exit(struct kvm_run *run,
> +			uint64_t test_dirty_quota_increment);
> +
>   #endif /* SELFTEST_KVM_UTIL_BASE_H */
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index d8cf851ab119..fa77558d745e 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -19,6 +19,7 @@
>   #include <linux/kernel.h>
>   
>   #define KVM_UTIL_MIN_PFN	2
> +#define PML_BUFFER_SIZE	512
>   
>   static int vcpu_mmap_sz(void);
>   
> @@ -2286,6 +2287,7 @@ static struct exit_reason {
>   	{KVM_EXIT_X86_RDMSR, "RDMSR"},
>   	{KVM_EXIT_X86_WRMSR, "WRMSR"},
>   	{KVM_EXIT_XEN, "XEN"},
> +	{KVM_EXIT_DIRTY_QUOTA_EXHAUSTED, "DIRTY_QUOTA_EXHAUSTED"},
>   #ifdef KVM_EXIT_MEMORY_NOT_PRESENT
>   	{KVM_EXIT_MEMORY_NOT_PRESENT, "MEMORY_NOT_PRESENT"},
>   #endif
> @@ -2517,3 +2519,37 @@ int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid)
>   
>   	return ioctl(vcpu->fd, KVM_GET_STATS_FD, NULL);
>   }
> +
> +void vcpu_set_dirty_quota(struct kvm_run *run, uint64_t dirty_quota)
> +{
> +	run->dirty_quota = dirty_quota;
> +
> +	if (dirty_quota)
> +		pr_info("Dirty quota throttling enabled with initial quota %"PRIu64"\n",
> +			dirty_quota);
> +	else
> +		pr_info("Dirty quota throttling disabled\n");
> +}
> +
> +void vcpu_handle_dirty_quota_exit(struct kvm_run *run,
> +			uint64_t test_dirty_quota_increment)
> +{
> +	uint64_t quota = run->dirty_quota_exit.quota;
> +	uint64_t count = run->dirty_quota_exit.count;
> +
> +	/*
> +	 * Due to PML, number of pages dirtied by the vcpu can exceed its dirty
> +	 * quota by PML buffer size.
> +	 */
> +	TEST_ASSERT(count <= quota + PML_BUFFER_SIZE, "Invalid number of pages
> +		dirtied: count=%"PRIu64", quota=%"PRIu64"\n", count, quota);
> +
> +	TEST_ASSERT(count >= quota, "Dirty quota exit happened with quota yet to
> +		be exhausted: count=%"PRIu64", quota=%"PRIu64"\n", count, quota);
> +
> +	if (count > quota)
> +		pr_info("Dirty quota exit with unequal quota and count:
> +			count=%"PRIu64", quota=%"PRIu64"\n", count, quota);
> +
> +	run->dirty_quota = count + test_dirty_quota_increment;
> +}
I'll be grateful if I could get some reviews on this patch. Will help me 
move forward. Thanks.
