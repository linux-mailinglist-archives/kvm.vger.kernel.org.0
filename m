Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E463812B2
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 23:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbhENVQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 17:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbhENVQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 17:16:48 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6523EC06175F
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 14:15:35 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id c15so69178ljr.7
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 14:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YP+eGppjVWkDeBhjcWdqIDPjokIVDbK7CXUMI0EcWQ8=;
        b=KaBisoHXMMYWihXKUSL49bKMKjyMoJXFcRiVd/42tDs4JHFQOhL+YomwBom+L0nNM/
         MvN+FT8kbmcJBRjWtUTwzMN4fXU3BG5dHfsexZJgKtLxbmRvL+eFMEp8ccxyXxA2wF0Q
         qbQT1ilO2LynIK4S+aZtpSsJdgFXcH2Doim+HgZV5yPrG4N+mq4hEuLZzDuNh6MSXWJx
         ev8s6aAEa02HhprBkA+r8z1SwOoKF3nBmJvuoz4B47ksOArm+FuNtVEVauzB6W9NXrAJ
         UpiBCdwwvFwsHgkG1bTrLuPvS/BDRpna5USYlUBbj91bQrpZuUb5GJPGg/fZ5LkSfs8s
         BzBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YP+eGppjVWkDeBhjcWdqIDPjokIVDbK7CXUMI0EcWQ8=;
        b=MEK8/XRRYJ8MKysBDK12gma59S7qZzF291EWh9xnoot47rDUNoVt1WHjgHf8oD2tlW
         21DboNcDU9JM37tJkseZGCbhSgdb/2Rf6HZks/hOGTjtbzNFPeB/8ueP/asiTQVlQOZb
         8KSKnCeMIhEqXeRUsDn2QCvt18zbTCVIqRrZHPM91FVS4Oyy4TAoxcGtiSBI/nDH/u+Z
         ePykCOg/WUl8UPfjm9DnBkdzOzF1u5/ncpx165LDTgCEa1yA3Fc3DsRJOZG6pbaOPfr8
         x2WOMioQJXwowZBNMEkt2sEd+23YS0pX1yJmi2E6pEZF0ubRbEqdHdqQF4v/B7im+1zO
         HnHg==
X-Gm-Message-State: AOAM531Fx27FR6L1XgCRkoB4n8dKPA8m1tVlQbhNWw/rbxFzfpyjN7hx
        UoAkhKLE1xMhKIXoz2pAhYXZE1hUSJcgMrBgz6QwXw==
X-Google-Smtp-Source: ABdhPJwc2Ye5WxUiCy3BRkJqAmQL9v+WCQgA5UntPr/ddkuothYSWXBDTDa46pUvThWX6lyJHfyb5IoU2JQRlXUDWHQ=
X-Received: by 2002:a2e:9a54:: with SMTP id k20mr40269513ljj.448.1621026933346;
 Fri, 14 May 2021 14:15:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210511220949.1019978-1-jmattson@google.com>
In-Reply-To: <20210511220949.1019978-1-jmattson@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 14 May 2021 14:15:07 -0700
Message-ID: <CALzav=e+eB1eH0DJSrPBp6a0sE-SYB5osn_7_ShHSWVgvjfb7w@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Convert vmx_tests.c comments to ASCII
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 3:10 PM Jim Mattson <jmattson@google.com> wrote:
>
> Some strange characters snuck into this file. Convert them to ASCII
> for better readability.
>
> Signed-off-by: Jim Mattson <jmattson@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  x86/vmx_tests.c | 44 ++++++++++++++++++++++----------------------
>  1 file changed, 22 insertions(+), 22 deletions(-)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 2eb5962..179a55b 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -4049,13 +4049,13 @@ static void test_pi_desc_addr(u64 addr, bool ctrl=
)
>  }
>
>  /*
> - * If the =C3=A2=E2=82=AC=C5=93process posted interrupts=C3=A2=E2=82=AC =
VM-execution control is 1, the
> + * If the "process posted interrupts" VM-execution control is 1, the
>   * following must be true:
>   *
> - *     - The =C3=A2=E2=82=AC=C5=93virtual-interrupt delivery=C3=A2=E2=82=
=AC VM-execution control is 1.
> - *     - The =C3=A2=E2=82=AC=C5=93acknowledge interrupt on exit=C3=A2=E2=
=82=AC VM-exit control is 1.
> + *     - The "virtual-interrupt delivery" VM-execution control is 1.
> + *     - The "acknowledge interrupt on exit" VM-exit control is 1.
>   *     - The posted-interrupt notification vector has a value in the
> - *     - range 0=C3=A2=E2=82=AC=E2=80=9C255 (bits 15:8 are all 0).
> + *     - range 0 - 255 (bits 15:8 are all 0).
>   *     - Bits 5:0 of the posted-interrupt descriptor address are all 0.
>   *     - The posted-interrupt descriptor address does not set any bits
>   *       beyond the processor's physical-address width.
> @@ -4179,7 +4179,7 @@ static void test_apic_ctls(void)
>  }
>
>  /*
> - * If the =C3=A2=E2=82=AC=C5=93enable VPID=C3=A2=E2=82=AC VM-execution c=
ontrol is 1, the value of the
> + * If the "enable VPID" VM-execution control is 1, the value of the
>   * of the VPID VM-execution control field must not be 0000H.
>   * [Intel SDM]
>   */
> @@ -4263,7 +4263,7 @@ static void test_invalid_event_injection(void)
>         vmcs_write(ENT_INTR_ERROR, 0x00000000);
>         vmcs_write(ENT_INST_LEN, 0x00000001);
>
> -       /* The field=E2=80=99s interruption type is not set to a reserved=
 value. */
> +       /* The field's interruption type is not set to a reserved value. =
*/
>         ent_intr_info =3D ent_intr_info_base | INTR_TYPE_RESERVED | DE_VE=
CTOR;
>         report_prefix_pushf("%s, VM-entry intr info=3D0x%x",
>                             "RESERVED interruption type invalid [-]",
> @@ -4480,7 +4480,7 @@ skip_unrestricted_guest:
>         /*
>          * If the interruption type is software interrupt, software excep=
tion,
>          * or privileged software exception, the VM-entry instruction-len=
gth
> -        * field is in the range 0=E2=80=9315.
> +        * field is in the range 0 - 15.
>          */
>
>         for (cnt =3D 0; cnt < 3; cnt++) {
> @@ -4686,8 +4686,8 @@ out:
>   *  VM-execution control must be 0.
>   *  [Intel SDM]
>   *
> - *  If the =E2=80=9Cvirtual NMIs=E2=80=9D VM-execution control is 0, the=
 =E2=80=9CNMI-window
> - *  exiting=E2=80=9D VM-execution control must be 0.
> + *  If the "virtual NMIs" VM-execution control is 0, the "NMI-window
> + *  exiting" VM-execution control must be 0.
>   *  [Intel SDM]
>   */
>  static void test_nmi_ctrls(void)
> @@ -5448,14 +5448,14 @@ static void test_vm_execution_ctls(void)
>    * the VM-entry MSR-load count field is non-zero:
>    *
>    *    - The lower 4 bits of the VM-entry MSR-load address must be 0.
> -  *      The address should not set any bits beyond the processor=C3=A2=
=E2=82=AC=E2=84=A2s
> +  *      The address should not set any bits beyond the processor's
>    *      physical-address width.
>    *
>    *    - The address of the last byte in the VM-entry MSR-load area
> -  *      should not set any bits beyond the processor=C3=A2=E2=82=AC=E2=
=84=A2s physical-address
> +  *      should not set any bits beyond the processor's physical-address
>    *      width. The address of this last byte is VM-entry MSR-load addre=
ss
>    *      + (MSR count * 16) - 1. (The arithmetic used for the computatio=
n
> -  *      uses more bits than the processor=C3=A2=E2=82=AC=E2=84=A2s phys=
ical-address width.)
> +  *      uses more bits than the processor's physical-address width.)
>    *
>    *
>    *  [Intel SDM]
> @@ -5574,14 +5574,14 @@ static void test_vm_entry_ctls(void)
>   * the VM-exit MSR-store count field is non-zero:
>   *
>   *    - The lower 4 bits of the VM-exit MSR-store address must be 0.
> - *      The address should not set any bits beyond the processor=E2=80=
=99s
> + *      The address should not set any bits beyond the processor's
>   *      physical-address width.
>   *
>   *    - The address of the last byte in the VM-exit MSR-store area
> - *      should not set any bits beyond the processor=E2=80=99s physical-=
address
> + *      should not set any bits beyond the processor's physical-address
>   *      width. The address of this last byte is VM-exit MSR-store addres=
s
>   *      + (MSR count * 16) - 1. (The arithmetic used for the computation
> - *      uses more bits than the processor=E2=80=99s physical-address wid=
th.)
> + *      uses more bits than the processor's physical-address width.)
>   *
>   * If IA32_VMX_BASIC[48] is read as 1, neither address should set any bi=
ts
>   * in the range 63:32.
> @@ -7172,7 +7172,7 @@ static void test_ctl_reg(const char *cr_name, u64 c=
r, u64 fixed0, u64 fixed1)
>   *    operation.
>   * 3. On processors that support Intel 64 architecture, the CR3 field mu=
st
>   *    be such that bits 63:52 and bits in the range 51:32 beyond the
> - *    processor=C3=A2=E2=82=AC=E2=84=A2s physical-address width must be =
0.
> + *    processor's physical-address width must be 0.
>   *
>   *  [Intel SDM]
>   */
> @@ -7940,11 +7940,11 @@ static void test_load_guest_pat(void)
>  #define MSR_IA32_BNDCFGS_RSVD_MASK     0x00000ffc
>
>  /*
> - * If the =C3=A2=E2=82=AC=C5=93load IA32_BNDCFGS=C3=A2=E2=82=AC VM-entry=
 control is 1, the following
> + * If the "load IA32_BNDCFGS" VM-entry control is 1, the following
>   * checks are performed on the field for the IA32_BNDCFGS MSR:
>   *
> - *   =C3=A2=E2=82=AC=E2=80=9D  Bits reserved in the IA32_BNDCFGS MSR mus=
t be 0.
> - *   =C3=A2=E2=82=AC=E2=80=9D  The linear address in bits 63:12 must be =
canonical.
> + *   - Bits reserved in the IA32_BNDCFGS MSR must be 0.
> + *   - The linear address in bits 63:12 must be canonical.
>   *
>   *  [Intel SDM]
>   */
> @@ -8000,9 +8000,9 @@ do {                                               =
                       \
>  /*
>   * The following checks are done on the Selector field of the Guest Segm=
ent
>   * Registers:
> - *    =E2=80=94 TR. The TI flag (bit 2) must be 0.
> - *    =E2=80=94 LDTR. If LDTR is usable, the TI flag (bit 2) must be 0.
> - *    =E2=80=94 SS. If the guest will not be virtual-8086 and the "unres=
tricted
> + *    - TR. The TI flag (bit 2) must be 0.
> + *    - LDTR. If LDTR is usable, the TI flag (bit 2) must be 0.
> + *    - SS. If the guest will not be virtual-8086 and the "unrestricted
>   *     guest" VM-execution control is 0, the RPL (bits 1:0) must equal
>   *     the RPL of the selector field for CS.
>   *
> --
> 2.31.1.607.g51e8a6a459-goog
>
