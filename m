Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 058AD135FDE
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 18:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388366AbgAIRwr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 9 Jan 2020 12:52:47 -0500
Received: from 14.mo3.mail-out.ovh.net ([188.165.43.98]:33546 "EHLO
        14.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730326AbgAIRwr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 12:52:47 -0500
X-Greylist: delayed 2342 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jan 2020 12:52:46 EST
Received: from player786.ha.ovh.net (unknown [10.109.143.210])
        by mo3.mail-out.ovh.net (Postfix) with ESMTP id 43B5423BF12
        for <kvm@vger.kernel.org>; Thu,  9 Jan 2020 18:13:43 +0100 (CET)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player786.ha.ovh.net (Postfix) with ESMTPSA id EDC85E344AED;
        Thu,  9 Jan 2020 17:13:26 +0000 (UTC)
Date:   Thu, 9 Jan 2020 18:13:25 +0100
From:   Greg Kurz <groug@kaod.org>
To:     Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Juan Quintela <quintela@redhat.com>, qemu-ppc@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        qemu-arm@nongnu.org, Alistair Francis <alistair.francis@wdc.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH 03/15] hw/ppc/spapr_rtas: Access MachineState via
 SpaprMachineState argument
Message-ID: <20200109181325.776d75a4@bahia.lan>
In-Reply-To: <20200109152133.23649-4-philmd@redhat.com>
References: <20200109152133.23649-1-philmd@redhat.com>
        <20200109152133.23649-4-philmd@redhat.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 6865456160021846307
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrvdeiuddgieefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfesthhqredtredtjeenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecukfhppedtrddtrddtrddtpdekvddrvdehfedrvddtkedrvdegkeenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrjeekiedrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehgrhhouhhgsehkrghougdrohhrghdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  9 Jan 2020 16:21:21 +0100
Philippe Mathieu-Daudé <philmd@redhat.com> wrote:

> We received a SpaprMachineState argument. Since SpaprMachineState
> inherits of MachineState, use it instead of calling qdev_get_machine.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---

Reviewed-by: Greg Kurz <groug@kaod.org>

>  hw/ppc/spapr_rtas.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/hw/ppc/spapr_rtas.c b/hw/ppc/spapr_rtas.c
> index e88bb1930e..6f06e9d7fe 100644
> --- a/hw/ppc/spapr_rtas.c
> +++ b/hw/ppc/spapr_rtas.c
> @@ -267,7 +267,7 @@ static void rtas_ibm_get_system_parameter(PowerPCCPU *cpu,
>                                            uint32_t nret, target_ulong rets)
>  {
>      PowerPCCPUClass *pcc = POWERPC_CPU_GET_CLASS(cpu);
> -    MachineState *ms = MACHINE(qdev_get_machine());
> +    MachineState *ms = MACHINE(spapr);
>      unsigned int max_cpus = ms->smp.max_cpus;
>      target_ulong parameter = rtas_ld(args, 0);
>      target_ulong buffer = rtas_ld(args, 1);

