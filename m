Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFE034ED3C
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 18:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhC3QKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 12:10:30 -0400
Received: from 9.mo51.mail-out.ovh.net ([46.105.48.137]:54047 "EHLO
        9.mo51.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbhC3QKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 12:10:14 -0400
X-Greylist: delayed 2392 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Mar 2021 12:10:14 EDT
Received: from mxplan5.mail.ovh.net (unknown [10.109.156.44])
        by mo51.mail-out.ovh.net (Postfix) with ESMTPS id 469BA27A325;
        Tue, 30 Mar 2021 16:52:08 +0200 (CEST)
Received: from kaod.org (37.59.142.97) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Tue, 30 Mar
 2021 16:52:07 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-97G002c055f940-b32b-40b8-803a-b962a7c5a5b9,
                    ACC3036D4A0BACA70991A0E48D5F19CB1CCAE693) smtp.auth=groug@kaod.org
X-OVh-ClientIp: 78.197.208.248
Date:   Tue, 30 Mar 2021 16:52:05 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Ravi Bangoria <ravi.bangoria@linux.ibm.com>
CC:     <paulus@samba.org>, <david@gibson.dropbear.id.au>,
        <mikey@neuling.org>, <kvm@vger.kernel.org>, <mst@redhat.com>,
        <mpe@ellerman.id.au>, <cohuck@redhat.com>, <qemu-devel@nongnu.org>,
        <qemu-ppc@nongnu.org>, <clg@kaod.org>, <pbonzini@redhat.com>
Subject: Re: [PATCH v3 2/3] ppc: Rename current DAWR macros and variables
Message-ID: <20210330165205.21c6443c@bahia.lan>
In-Reply-To: <20210330095350.36309-3-ravi.bangoria@linux.ibm.com>
References: <20210330095350.36309-1-ravi.bangoria@linux.ibm.com>
        <20210330095350.36309-3-ravi.bangoria@linux.ibm.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.97]
X-ClientProxiedBy: DAG5EX2.mxp5.local (172.16.2.42) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: df34418c-3a83-4e4d-92e9-174410d45fa9
X-Ovh-Tracer-Id: 4258153449415481848
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrudeitddgkedvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfhisehtjeertdertddvnecuhfhrohhmpefirhgvghcumfhurhiiuceoghhrohhugheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeefuddtieejjeevheekieeltefgleetkeetheettdeifeffvefhffelffdtfeeljeenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddrleejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehgrhhouhhgsehkrghougdrohhrghdprhgtphhtthhopegtlhhgsehkrghougdrohhrgh
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 30 Mar 2021 15:23:49 +0530
Ravi Bangoria <ravi.bangoria@linux.ibm.com> wrote:

> Power10 is introducing second DAWR. Use real register names (with
> suffix 0) from ISA for current macros and variables used by Qemu.
> 
> One exception to this is KVM_REG_PPC_DAWR[X]. This is from kernel
> uapi header and thus not changed in kernel as well as Qemu.
> 
> Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
> ---

Reviewed-by: Greg Kurz <groug@kaod.org>

>  include/hw/ppc/spapr.h          | 2 +-
>  target/ppc/cpu.h                | 4 ++--
>  target/ppc/translate_init.c.inc | 4 ++--
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> index 47cebaf3ac..b8985fab5b 100644
> --- a/include/hw/ppc/spapr.h
> +++ b/include/hw/ppc/spapr.h
> @@ -363,7 +363,7 @@ struct SpaprMachineState {
>  
>  /* Values for 2nd argument to H_SET_MODE */
>  #define H_SET_MODE_RESOURCE_SET_CIABR           1
> -#define H_SET_MODE_RESOURCE_SET_DAWR            2
> +#define H_SET_MODE_RESOURCE_SET_DAWR0           2
>  #define H_SET_MODE_RESOURCE_ADDR_TRANS_MODE     3
>  #define H_SET_MODE_RESOURCE_LE                  4
>  
> diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
> index e73416da68..cd02d65303 100644
> --- a/target/ppc/cpu.h
> +++ b/target/ppc/cpu.h
> @@ -1459,10 +1459,10 @@ typedef PowerPCCPU ArchCPU;
>  #define SPR_MPC_BAR           (0x09F)
>  #define SPR_PSPB              (0x09F)
>  #define SPR_DPDES             (0x0B0)
> -#define SPR_DAWR              (0x0B4)
> +#define SPR_DAWR0             (0x0B4)
>  #define SPR_RPR               (0x0BA)
>  #define SPR_CIABR             (0x0BB)
> -#define SPR_DAWRX             (0x0BC)
> +#define SPR_DAWRX0            (0x0BC)
>  #define SPR_HFSCR             (0x0BE)
>  #define SPR_VRSAVE            (0x100)
>  #define SPR_USPRG0            (0x100)
> diff --git a/target/ppc/translate_init.c.inc b/target/ppc/translate_init.c.inc
> index c03a7c4f52..879e6df217 100644
> --- a/target/ppc/translate_init.c.inc
> +++ b/target/ppc/translate_init.c.inc
> @@ -7748,12 +7748,12 @@ static void gen_spr_book3s_dbg(CPUPPCState *env)
>  
>  static void gen_spr_book3s_207_dbg(CPUPPCState *env)
>  {
> -    spr_register_kvm_hv(env, SPR_DAWR, "DAWR",
> +    spr_register_kvm_hv(env, SPR_DAWR0, "DAWR0",
>                          SPR_NOACCESS, SPR_NOACCESS,
>                          SPR_NOACCESS, SPR_NOACCESS,
>                          &spr_read_generic, &spr_write_generic,
>                          KVM_REG_PPC_DAWR, 0x00000000);
> -    spr_register_kvm_hv(env, SPR_DAWRX, "DAWRX",
> +    spr_register_kvm_hv(env, SPR_DAWRX0, "DAWRX0",
>                          SPR_NOACCESS, SPR_NOACCESS,
>                          SPR_NOACCESS, SPR_NOACCESS,
>                          &spr_read_generic, &spr_write_generic,

