Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6548C308BEB
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 18:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhA2RtA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 12:49:00 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36422 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbhA2Rqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 12:46:37 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10THdKxs148839;
        Fri, 29 Jan 2021 17:44:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=ZCFVRgH0AFWYIU89l0YoNjDWlWqUS28BrWMKWAy4jfk=;
 b=pOgWosCzOYuK3MPBRuTOECZsdnt1V5bs27XqJgCceIAF48WLxUpOoOGRLlMroqrqeQWB
 Cd2KpJm3kXSABCqvFY1jTITHlQFHnnh8PqJe7dXaUHxclDJw1P2pE6uZPr9UMB94kKcf
 0GURqe4VmMf1TFJ9sFdYn9hVhWaV2srN7aYtZ4Et53gf1QUL+W6B9I6pV8CJI+i5oBKj
 USMOwF6SRfvhkfs6Dyq/AuzgwoWl8S0HfKHP8U40ymOZ40wA6DCVtqRVpp+ZAYvua5bn
 g1U/Yq5Qypt5gNvLeul0gkHJCIfXZtlKxTHGuFf7AhdrZh7e12vi6SHqKiX6TEKxNJ1R 5Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 3689ab2pmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:44:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10THikD7185343;
        Fri, 29 Jan 2021 17:44:54 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3020.oracle.com with ESMTP id 36ceug6jxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:44:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UeEzdi5xslhj9zlNZuOy5bH5619KQjE2IDR5jO6Mvj1Ub1s5xgq7HNs8h4Va5A7N/BoFiBzJhxsIQSiMktNc6a84SuN+8FUCQXKsP+1PuzXqNnY+Y0/X7PIBawoDZ1wD4IFi/+Sc76cyO2o8ZpUTZnVMUkCeY16BR7ZBAEW3IqZkOw+wLWj4zqpGDj838TpjILnEN1Bi+j9xnucsZpw8NdX8n5MslHUsX75Uhm9nTRHq6+vxQ2QLUsmW/Zh+bw2Ll1b+N3JxcfKagBCGXb+bFSqrJtApGlXGcfVP1o8QhNGNEoV0Ljiw7T4qapq/L6Sc5zoxrInjY7BHwpohfHjLeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZCFVRgH0AFWYIU89l0YoNjDWlWqUS28BrWMKWAy4jfk=;
 b=Z+b47K/AeCPPTUcC9ZtR6KIzUbZd+YAuqbFXzf8dkzTuiQaEdwAXa+T+Xl0clgiFFoio0RvnUDZkZE48j4VbCxth9C7yhViChtE/1xqSjQWYjYU92+Rq1Y513K1uyP8CZXw1HCBOXuCrJ1fdIhyG6U4BPVkjdo/Lla+VWu7aRALSaua6iOPYB+qwyzViC6QpYwQXe6e83t8X2lXNrK1ZOFe9FxvAQVh8/97v3A39bLCNmhl3p9E+J4rUeT1YOcH2nizkw+HDBpDwFtdkZj8HE6rvfgXnDCRcF6bqWOhErOKZ9as+tEAbymBMjUNjWp0EHow6UeVZ3OhigSAEO9MNiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZCFVRgH0AFWYIU89l0YoNjDWlWqUS28BrWMKWAy4jfk=;
 b=EHbNQeler5tkREMlxNSKruGZNPOrmSk+ZwbMwa2igSJLphG3UNdXZLwUQKTvwCJ3NNyXF5AjtcRxn0zc6cML0IgPO6PzJoN7IkPTc+dzWrraArivkMmEMGSs0nf0kRi1L4Fb9HUFaIFCCg/lM6xP0GqMYaK6FxcPdPdMhuyNbSc=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB2044.namprd10.prod.outlook.com (2603:10b6:3:110::17)
 by DM6PR10MB3018.namprd10.prod.outlook.com (2603:10b6:5:6d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 17:44:52 +0000
Received: from DM5PR10MB2044.namprd10.prod.outlook.com
 ([fe80::3c1b:996a:6c0f:5bbe]) by DM5PR10MB2044.namprd10.prod.outlook.com
 ([fe80::3c1b:996a:6c0f:5bbe%6]) with mapi id 15.20.3805.019; Fri, 29 Jan 2021
 17:44:52 +0000
Date:   Fri, 29 Jan 2021 11:44:45 -0600
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v6 4/6] sev/i386: Don't allow a system reset under an
 SEV-ES guest
Message-ID: <20210129174445.GD231819@dt>
References: <cover.1611682609.git.thomas.lendacky@amd.com>
 <1ac39c441b9a3e970e9556e1cc29d0a0814de6fd.1611682609.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ac39c441b9a3e970e9556e1cc29d0a0814de6fd.1611682609.git.thomas.lendacky@amd.com>
X-Originating-IP: [209.17.40.36]
X-ClientProxiedBy: SJ0PR03CA0082.namprd03.prod.outlook.com
 (2603:10b6:a03:331::27) To DM5PR10MB2044.namprd10.prod.outlook.com
 (2603:10b6:3:110::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dt (209.17.40.36) by SJ0PR03CA0082.namprd03.prod.outlook.com (2603:10b6:a03:331::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Fri, 29 Jan 2021 17:44:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a9bb8d3-9956-41c0-17cd-08d8c47d94f1
X-MS-TrafficTypeDiagnostic: DM6PR10MB3018:
X-Microsoft-Antispam-PRVS: <DM6PR10MB301874464FE2A57C28C7B30BE6B99@DM6PR10MB3018.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ppqWwi9t0TnGGK/+5LpHKUnqJve3GcjquKm/FcH6TDPUo+6xfcfvyh8i4gEtVid/V9Sy96bYzM67poZPxYIC45x3V8MTDXJI6ulfrZsEEdSwUm51laJY1yYr3zoSuif7lakfUjf0ptbyJ3cn/3gRb6Ht34ufE3Q43+1Ogzdn0PS0uG/8L0mD8qUo8Yck8ZLik3iQ6IqXvfyoIGvcid1PWy5DhVCx+GWJty7cv51TB6YaPxJCA7hnV9bx7FSVuuFJT3o9ASkH6TtmJT4oCMsQdT47Sqi2jdGHVrzbDeZRNp9bcBGHnfmRTbd1o3eZ4v0fCWuRFybsHpxYb23P2LyndOcnik1uPfOijiG76sPfoxqi8lYv2qa0kJaxwP+e0//TjMeWg7Qxux8ZCQlyCefr2Q/dd6oTvejMtWpiIdpJMqxxnnJfRFlPdJ7J4c+ZSPDzwtvmAN5GoPVWwyYdK/4957xvZJd37KOwU2UcjkJdFSMYRhB0uLME6B0d/WpIsYCvv+L6yA0WV4HLPGmm7stCmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB2044.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(346002)(136003)(376002)(33656002)(55016002)(186003)(9576002)(6666004)(16526019)(7416002)(8936002)(86362001)(9686003)(2906002)(1076003)(54906003)(6916009)(6496006)(4326008)(5660300002)(52116002)(66946007)(44832011)(66556008)(956004)(53546011)(26005)(8676002)(478600001)(33716001)(83380400001)(316002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jQQts0TzV8rPt8s0EcJkVsfDkWYrDukzj1R6ypKXX2mjB0X4PVhpM8LDRRWd?=
 =?us-ascii?Q?+8LUxB2yDPv2SoBuXoAyHNjZy/jAwQCjePbURbNLl0bA4Nr/cFf5iXJ8I55t?=
 =?us-ascii?Q?sxsAQLOv5CrK/vxAoO2p57HdFsauOuYs+QTnWoWgAVh/be4hLAy+uND7Stqr?=
 =?us-ascii?Q?5OdPZfvBuC1tizFmledD+LCKdNIr+8WClByCaKlynhOq1wY+TY6YzAoh2l0a?=
 =?us-ascii?Q?tZQTW0KqhP4UwfBXqlpwap4puT4zu2puAWsatHli8L0UyUTwlv92V8Aqj9Q/?=
 =?us-ascii?Q?d7kcRsUauLt41DqdDpXLL7DegyFZNpSQzEGhuy1otd02PSh5NxXh84/7Ip79?=
 =?us-ascii?Q?WTSF9NOsWBtpX+EAZzUZxvST4CkFVF8Fp1Ty70/KP+nF/gPeCvQf5GMA/1Wg?=
 =?us-ascii?Q?pPD0e2WgXPdV47mwG9oLd59iOQ8bXi4Pq+CzuwLCQ1NpFrfEhgEtdOCN3ZEC?=
 =?us-ascii?Q?hybN/tnU/a6E1YQoHS6LkV8r7iaYH4v8f5lNfi1Ne8GZbEOtChMXLgLP9XTJ?=
 =?us-ascii?Q?+P99jCavSeJHmkPPbJ6zwfI0OBorGEurVLjlylpAv5Rnt/6n1dKO9MM/dC2b?=
 =?us-ascii?Q?sWp2J79Ns2gJg3AgW7h0jQ5IfRhmcnIwuvA44ivj8taWc86F+bg1cS0A+/og?=
 =?us-ascii?Q?g1/TsGvAvEkodTeenIdgzUn6jk4l+psFULBp9YT5SnW1f5jfvm8WxDg4RROa?=
 =?us-ascii?Q?f+wjoTIwpic2SW7Hky9li/cWmXuE7NV9l07Ur03siFkjRHLzb73GEJsgRGlp?=
 =?us-ascii?Q?oNm1wW6RhZlGghz0qyeEZMsvVNNzUHZnp9hPgHZs4gHRiol1i0TyIpUgxDjk?=
 =?us-ascii?Q?OMWpyfOqW0XNp4uW0LqMbld1HUaAapM7Ei624QkCDaYDeoUW6xlgZw6ik9Sj?=
 =?us-ascii?Q?n1b71Lcq4XRaX0wFwCnjqAZ+jnMMIApApfFfJFiHBXcwGOjMGFsGilC/jAej?=
 =?us-ascii?Q?MXxrcizFtDal4pexp2ZCuS6ddACRFoE3NsoAkWxs2l+szyT1ZJtGKa2gQsR5?=
 =?us-ascii?Q?sQQrMqFYLIv+rt2YZ/AedYiC9+A6oOlGRjt+0Ipsc1Lifi4t0AUnF82s2Nkh?=
 =?us-ascii?Q?xTm89pLT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a9bb8d3-9956-41c0-17cd-08d8c47d94f1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB2044.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 17:44:52.3608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1OYlRvBgXLT5uhwviuyq4BQ82Ovb55qn6aKxfKfrkKQdJ3Lt2mZoNRVYdg8C6aDizN1ht7qRzTU+vfJ8k0D3BzYTVetJ0vNM6dYISpy7/68=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3018
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290087
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-01-26 11:36:47 -0600, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> An SEV-ES guest does not allow register state to be altered once it has
> been measured. When an SEV-ES guest issues a reboot command, Qemu will
> reset the vCPU state and resume the guest. This will cause failures under
> SEV-ES. Prevent that from occuring by introducing an arch-specific
> callback that returns a boolean indicating whether vCPUs are resettable.
> 
> Cc: Peter Maydell <peter.maydell@linaro.org>
> Cc: Aurelien Jarno <aurelien@aurel32.net>
> Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Cc: Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Cc: David Hildenbrand <david@redhat.com>
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>

> ---
>  accel/kvm/kvm-all.c       |  5 +++++
>  include/sysemu/cpus.h     |  2 ++
>  include/sysemu/hw_accel.h |  5 +++++
>  include/sysemu/kvm.h      | 10 ++++++++++
>  softmmu/cpus.c            |  5 +++++
>  softmmu/runstate.c        |  3 +++
>  target/arm/kvm.c          |  5 +++++
>  target/i386/kvm/kvm.c     |  6 ++++++
>  target/mips/kvm.c         |  5 +++++
>  target/ppc/kvm.c          |  5 +++++
>  target/s390x/kvm.c        |  5 +++++
>  11 files changed, 56 insertions(+)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 410879cf94..6c099a3869 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2414,6 +2414,11 @@ void kvm_flush_coalesced_mmio_buffer(void)
>      s->coalesced_flush_in_progress = false;
>  }
>  
> +bool kvm_cpu_check_are_resettable(void)
> +{
> +    return kvm_arch_cpu_check_are_resettable();
> +}
> +
>  static void do_kvm_cpu_synchronize_state(CPUState *cpu, run_on_cpu_data arg)
>  {
>      if (!cpu->vcpu_dirty) {
> diff --git a/include/sysemu/cpus.h b/include/sysemu/cpus.h
> index e8156728c6..1cb4f9dbeb 100644
> --- a/include/sysemu/cpus.h
> +++ b/include/sysemu/cpus.h
> @@ -57,6 +57,8 @@ extern int icount_align_option;
>  /* Unblock cpu */
>  void qemu_cpu_kick_self(void);
>  
> +bool cpus_are_resettable(void);
> +
>  void cpu_synchronize_all_states(void);
>  void cpu_synchronize_all_post_reset(void);
>  void cpu_synchronize_all_post_init(void);
> diff --git a/include/sysemu/hw_accel.h b/include/sysemu/hw_accel.h
> index ffed6192a3..61672f9b32 100644
> --- a/include/sysemu/hw_accel.h
> +++ b/include/sysemu/hw_accel.h
> @@ -22,4 +22,9 @@ void cpu_synchronize_post_reset(CPUState *cpu);
>  void cpu_synchronize_post_init(CPUState *cpu);
>  void cpu_synchronize_pre_loadvm(CPUState *cpu);
>  
> +static inline bool cpu_check_are_resettable(void)
> +{
> +    return kvm_enabled() ? kvm_cpu_check_are_resettable() : true;
> +}
> +
>  #endif /* QEMU_HW_ACCEL_H */
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index 875ca101e3..3e265cea3d 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -573,4 +573,14 @@ int kvm_get_max_memslots(void);
>  /* Notify resamplefd for EOI of specific interrupts. */
>  void kvm_resample_fd_notify(int gsi);
>  
> +/**
> + * kvm_cpu_check_are_resettable - return whether CPUs can be reset
> + *
> + * Returns: true: CPUs are resettable
> + *          false: CPUs are not resettable
> + */
> +bool kvm_cpu_check_are_resettable(void);
> +
> +bool kvm_arch_cpu_check_are_resettable(void);
> +
>  #endif
> diff --git a/softmmu/cpus.c b/softmmu/cpus.c
> index 1dc20b9dc3..89de46eae0 100644
> --- a/softmmu/cpus.c
> +++ b/softmmu/cpus.c
> @@ -194,6 +194,11 @@ void cpu_synchronize_pre_loadvm(CPUState *cpu)
>      }
>  }
>  
> +bool cpus_are_resettable(void)
> +{
> +    return cpu_check_are_resettable();
> +}
> +
>  int64_t cpus_get_virtual_clock(void)
>  {
>      /*
> diff --git a/softmmu/runstate.c b/softmmu/runstate.c
> index beee050815..1813691898 100644
> --- a/softmmu/runstate.c
> +++ b/softmmu/runstate.c
> @@ -527,6 +527,9 @@ void qemu_system_reset_request(ShutdownCause reason)
>      if (reboot_action == REBOOT_ACTION_SHUTDOWN &&
>          reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
>          shutdown_requested = reason;
> +    } else if (!cpus_are_resettable()) {
> +        error_report("cpus are not resettable, terminating");
> +        shutdown_requested = reason;
>      } else {
>          reset_requested = reason;
>      }
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index ffe186de8d..00e124c812 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -1045,3 +1045,8 @@ int kvm_arch_msi_data_to_gsi(uint32_t data)
>  {
>      return (data - 32) & 0xffff;
>  }
> +
> +bool kvm_arch_cpu_check_are_resettable(void)
> +{
> +    return true;
> +}
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index aaae79557d..bb6bfc19de 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -27,6 +27,7 @@
>  #include "sysemu/kvm_int.h"
>  #include "sysemu/runstate.h"
>  #include "kvm_i386.h"
> +#include "sev_i386.h"
>  #include "hyperv.h"
>  #include "hyperv-proto.h"
>  
> @@ -4788,3 +4789,8 @@ bool kvm_has_waitpkg(void)
>  {
>      return has_msr_umwait;
>  }
> +
> +bool kvm_arch_cpu_check_are_resettable(void)
> +{
> +    return !sev_es_enabled();
> +}
> diff --git a/target/mips/kvm.c b/target/mips/kvm.c
> index 84fb10ea35..123ec1be7e 100644
> --- a/target/mips/kvm.c
> +++ b/target/mips/kvm.c
> @@ -1290,3 +1290,8 @@ int mips_kvm_type(MachineState *machine, const char *vm_type)
>  
>      return -1;
>  }
> +
> +bool kvm_arch_cpu_check_are_resettable(void)
> +{
> +    return true;
> +}
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index daf690a678..f45ed11058 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -2947,3 +2947,8 @@ void kvmppc_svm_off(Error **errp)
>          error_setg_errno(errp, -rc, "KVM_PPC_SVM_OFF ioctl failed");
>      }
>  }
> +
> +bool kvm_arch_cpu_check_are_resettable(void)
> +{
> +    return true;
> +}
> diff --git a/target/s390x/kvm.c b/target/s390x/kvm.c
> index dc27fa36c9..7a892d663d 100644
> --- a/target/s390x/kvm.c
> +++ b/target/s390x/kvm.c
> @@ -2599,3 +2599,8 @@ void kvm_s390_stop_interrupt(S390CPU *cpu)
>  
>      kvm_s390_vcpu_interrupt(cpu, &irq);
>  }
> +
> +bool kvm_arch_cpu_check_are_resettable(void)
> +{
> +    return true;
> +}
> -- 
> 2.30.0
> 
