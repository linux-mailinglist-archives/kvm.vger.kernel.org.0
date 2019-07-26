Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8150575ECE
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2019 08:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbfGZGQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jul 2019 02:16:26 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:35080 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbfGZGQ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jul 2019 02:16:26 -0400
Received: by mail-oi1-f196.google.com with SMTP id a127so39463539oii.2;
        Thu, 25 Jul 2019 23:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bWhcVowPDp5hww55kUYR42YNfTJnzOgRCOisQOx0g5s=;
        b=i41rX2aTdMFTYSrfy9XMiDfTAIJm9h+bgaZvpHOA+SPg5d99/C6dHyeIHGk4KCaFao
         1ZT0D+D/IfrwH7O71FkAmavofjcNhTJ0YKNBuDDhZv0qNpJpINrcfSkkm6e5h15s9szf
         YCyDULz2DXMccGSxgq2b9QxyUHkpv332Cj2p8VhQ69hzN43eh/DQ+84B40Ura4Mp+qeD
         bvLUd02WctRRazTQTAXJWVTIDcMmki7PSnrFyUtoBUqv4VuxksraAPZIgGWBbbfbuJOL
         TQINF1j2AP7/dvKVhVotnu6NQvxYhAAMka/da0whexdPPT1HSgpo2ebJtLOiz9qJpCfV
         /QYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bWhcVowPDp5hww55kUYR42YNfTJnzOgRCOisQOx0g5s=;
        b=Rr9YXPLXxNU6SSIkVPpB0XDtTdmNSN6k3SMhxinDILmSfME39LPOuNb+J5ofE5jOYq
         ACOKtuOkzV2eMKR+EBR1Ph54tYQflEIHSCIw30PdQrLBcpm9gHlIOWRFQRxp1yMNJWcM
         KDluPchFB+W0z9jU0rH9oRv7zrTDlIpJihHb+taOcH0mtIumyG2nah8H9l59OppYwzx5
         XrwQ0nJb5afNREHJZ4TP3Fr/0aPV98zQXRvT71EQb/k58aWtHMtPUw9qKUwh+m88JLkz
         IxhSoOojGUwmhjRBUtnGUip76WxYiVPv2zQukd/bt1IABC+LVEW5jyVnMwzoiZP+FKBA
         fGPQ==
X-Gm-Message-State: APjAAAUXlL+8Oc+NSXmlkJD+DQWZGbVR40DjPWnoO18GsgWQgZvbhLHu
        MdLh8sGfl30JIkeccU73LN3ENzewpVYlL1aieYPnRADn
X-Google-Smtp-Source: APXvYqwv3JC1s4kna2Bb8F2eEFKDnwTsNmkpWgJIXeODkwLjwGADjmSwZCwdOnpmrogbPYJT+/uqzZF6HSellt1nkTw=
X-Received: by 2002:aca:3dd7:: with SMTP id k206mr41464700oia.47.1564121784919;
 Thu, 25 Jul 2019 23:16:24 -0700 (PDT)
MIME-Version: 1.0
References: <1564121417-29375-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1564121417-29375-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 26 Jul 2019 14:16:11 +0800
Message-ID: <CANRm+CzTJ6dCv=NSHLGV-uWdaES2F0T7PXgu0LXXEsBCJ8mxEA@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Use IPI shorthands in kvm guest when support
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Nadav Amit <namit@vmware.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Jul 2019 at 14:10, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> IPI shorthand is supported now by linux apic/x2apic driver, switch to
> IPI shorthand for all excluding self and all including self destination
> shorthand in kvm guest, to avoid splitting the target mask into serveral
> PV IPI hypercalls.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Nadav Amit <namit@vmware.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> Note: rebase against tip tree's x86/apic branch
>
>  arch/x86/kernel/kvm.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index b7f34fe..87b73b8 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -34,7 +34,9 @@
>  #include <asm/hypervisor.h>
>  #include <asm/tlb.h>
>
> +static struct apic orig_apic;
>  static int kvmapf =3D 1;
> +DECLARE_STATIC_KEY_FALSE(apic_use_ipi_shorthand);
>
>  static int __init parse_no_kvmapf(char *arg)
>  {
> @@ -507,12 +509,18 @@ static void kvm_send_ipi_mask_allbutself(const stru=
ct cpumask *mask, int vector)
>
>  static void kvm_send_ipi_allbutself(int vector)
>  {
> -       kvm_send_ipi_mask_allbutself(cpu_online_mask, vector);
> +       if (static_branch_likely(&apic_use_ipi_shorthand))
> +               orig_apic.send_IPI_allbutself(vector);
> +       else
> +               kvm_send_ipi_mask_allbutself(cpu_online_mask, vector);
>  }
>
>  static void kvm_send_ipi_all(int vector)
>  {
> -       __send_ipi_mask(cpu_online_mask, vector);
> +       if (static_branch_likely(&apic_use_ipi_shorthand))
> +               orig_apic.send_IPI_allbutself(vector);

Make a mistake here, just resend the patch.

> +       else
> +               __send_ipi_mask(cpu_online_mask, vector);
>  }
>
>  /*
> @@ -520,6 +528,8 @@ static void kvm_send_ipi_all(int vector)
>   */
>  static void kvm_setup_pv_ipi(void)
>  {
> +       orig_apic =3D *apic;
> +
>         apic->send_IPI_mask =3D kvm_send_ipi_mask;
>         apic->send_IPI_mask_allbutself =3D kvm_send_ipi_mask_allbutself;
>         apic->send_IPI_allbutself =3D kvm_send_ipi_allbutself;
> --
> 2.7.4
>
