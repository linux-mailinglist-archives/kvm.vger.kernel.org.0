Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49725669EF
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 11:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfGLJaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 05:30:24 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40280 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbfGLJaY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 05:30:24 -0400
Received: by mail-wr1-f65.google.com with SMTP id r1so9196438wrl.7;
        Fri, 12 Jul 2019 02:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=sXM7tRmdw5JLvtzlXPCQvimlB2RjvKIPilkRGUjvSNQ=;
        b=Ni1euwE2ECJaoCd9a/bzAtrT4vq0jNRiSnI/ABN165oVkDf/jRHUPINZKDyn1WFJIp
         X5jviyH/+5NFsDh6yu3tnv0C3Pv7Q+n5h5ZQJRCb3qD3TuZpYX6O4UwbIliuOeqe/vp8
         Os4khUAgVVh9qWhOnh8h0BUneno4jXq4kx1kwSrH+XUUOpT5JjLuBthqXwI8JqQHJsI/
         rGV6RGZaHfy3dz7/qQcehXSrPVkm8ICtAZAEHarjRy6UsmypBOvbVxwc/DXb1Ff++JYw
         5+qmeSMbIJbgE6gGxDEXtusAg8rC9URQq8c+6x1FDWamzxMA/01YBnPx1xDd4n+iFHzm
         /Nfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=sXM7tRmdw5JLvtzlXPCQvimlB2RjvKIPilkRGUjvSNQ=;
        b=De3jE35amNzIAp9w2OMayLLqrZ+gT+THaXe0Yh1fEbB2UtMNu4GCsXBG/P1zpcbmoS
         4ZNnyxGPnw9T9t+P/m6bFvtt1QqeNn9KCxIKa6ndOZV2E0BTsX8/6m+otEmgwncfQdig
         Q7ftIlphLZVEgxg3hid7Cc7YS1nCaiekG//cUXXNZcdYmAwwEXaVfu7s0RSCUh1TAeQg
         tDX4MgcpGAT8wK73HkyV9+ZQulnNXpU/0I+e9qPMgfSU0Dl345chPd7wI3j2SbkjRGS7
         GkCgllr8hIAojIhxK1okPIVVAJLLSQ6xkY0aokaRfxmOh/LlX1Zc3sdnr91j6niOZDZs
         tPGg==
X-Gm-Message-State: APjAAAW/AuOK0cpugpswdtSeWm0s/m0CCrZugcwDPw4Vn1hpueGTyftZ
        4CX6Nn90tybQLWyi9jg2kHAmIPRd1NcWhqvMJDQ=
X-Google-Smtp-Source: APXvYqzVf73c+YxtMn7MvKOhKJh0dLo8M0biSrKTkQDwypJLNg/V+UzAwROXtKGCcxr1GhZNXJnOqtGdBgUWg2wAU0g=
X-Received: by 2002:a5d:4403:: with SMTP id z3mr10886473wrq.29.1562923821526;
 Fri, 12 Jul 2019 02:30:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190712091239.716978-1-arnd@arndb.de> <20190712091239.716978-2-arnd@arndb.de>
In-Reply-To: <20190712091239.716978-2-arnd@arndb.de>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Fri, 12 Jul 2019 11:30:10 +0200
Message-ID: <CA+icZUU2kfEbDjEgaQPY9WhNfeSAkMAS6YrscqxVS4E8CYUTvg@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86: kvm: avoid constant-conversion warning
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Junaid Shahid <junaids@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Kai Huang <kai.huang@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
Content-Type: multipart/mixed; boundary="00000000000031a3a8058d788f42"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--00000000000031a3a8058d788f42
Content-Type: text/plain; charset="UTF-8"

On Fri, Jul 12, 2019 at 11:12 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> clang finds a contruct suspicious that converts an unsigned
> character to a signed integer and back, causing an overflow:
>
> arch/x86/kvm/mmu.c:4605:39: error: implicit conversion from 'int' to 'u8' (aka 'unsigned char') changes value from -205 to 51 [-Werror,-Wconstant-conversion]
>                 u8 wf = (pfec & PFERR_WRITE_MASK) ? ~w : 0;
>                    ~~                               ^~
> arch/x86/kvm/mmu.c:4607:38: error: implicit conversion from 'int' to 'u8' (aka 'unsigned char') changes value from -241 to 15 [-Werror,-Wconstant-conversion]
>                 u8 uf = (pfec & PFERR_USER_MASK) ? ~u : 0;
>                    ~~                              ^~
> arch/x86/kvm/mmu.c:4609:39: error: implicit conversion from 'int' to 'u8' (aka 'unsigned char') changes value from -171 to 85 [-Werror,-Wconstant-conversion]
>                 u8 ff = (pfec & PFERR_FETCH_MASK) ? ~x : 0;
>                    ~~                               ^~
>
> Add an explicit cast to tell clang that everything works as
> intended here.
>

Feel free to add:

Link: https://github.com/ClangBuiltLinux/linux/issues/95
( See also patch proposal of Matthias Kaehlcke )

I had a different "simpler" approach to not see this anymore :-).
( See attached 2 patches )

- Sedat -


> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/x86/kvm/mmu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 17ece7b994b1..aea7f969ecb8 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -4602,11 +4602,11 @@ static void update_permission_bitmask(struct kvm_vcpu *vcpu,
>                  */
>
>                 /* Faults from writes to non-writable pages */
> -               u8 wf = (pfec & PFERR_WRITE_MASK) ? ~w : 0;
> +               u8 wf = (pfec & PFERR_WRITE_MASK) ? (u8)~w : 0;
>                 /* Faults from user mode accesses to supervisor pages */
> -               u8 uf = (pfec & PFERR_USER_MASK) ? ~u : 0;
> +               u8 uf = (pfec & PFERR_USER_MASK) ? (u8)~u : 0;
>                 /* Faults from fetches of non-executable pages*/
> -               u8 ff = (pfec & PFERR_FETCH_MASK) ? ~x : 0;
> +               u8 ff = (pfec & PFERR_FETCH_MASK) ? (u8)~x : 0;
>                 /* Faults from kernel mode fetches of user pages */
>                 u8 smepf = 0;
>                 /* Faults from kernel mode accesses of user pages */
> --
> 2.20.0
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20190712091239.716978-2-arnd%40arndb.de.

--00000000000031a3a8058d788f42
Content-Type: application/x-patch; 
	name="0001-kbuild-Enable-Wconstant-conversion-warning-for-make-.patch"
Content-Disposition: attachment; 
	filename="0001-kbuild-Enable-Wconstant-conversion-warning-for-make-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jxzw8q9a0>
X-Attachment-Id: f_jxzw8q9a0

RnJvbSBiZmMzMmQ3ZjZjOGQ1YmQ3NzY2ZTQyOTJlMjVhMTg0NzQzYTRiM2IxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAY3JlZGF0aXYuZGU+
CkRhdGU6IFR1ZSwgMTkgTWFyIDIwMTkgMDg6NTY6MDIgKzAxMDAKU3ViamVjdDogW1BBVENIXSBr
YnVpbGQ6IEVuYWJsZSAtV2NvbnN0YW50LWNvbnZlcnNpb24gd2FybmluZyBmb3IgIm1ha2UgVz0z
IgoKLS0tCiBzY3JpcHRzL01ha2VmaWxlLmV4dHJhd2FybiB8IDEgKwogMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspCgpkaWZmIC0tZ2l0IGEvc2NyaXB0cy9NYWtlZmlsZS5leHRyYXdhcm4g
Yi9zY3JpcHRzL01ha2VmaWxlLmV4dHJhd2FybgppbmRleCA3NjgzMDZhZGQ1OTEuLmViODMxYThj
NmEyMCAxMDA2NDQKLS0tIGEvc2NyaXB0cy9NYWtlZmlsZS5leHRyYXdhcm4KKysrIGIvc2NyaXB0
cy9NYWtlZmlsZS5leHRyYXdhcm4KQEAgLTQ3LDYgKzQ3LDcgQEAgd2FybmluZy0yICs9ICQoY2Fs
bCBjYy1vcHRpb24sIC1XdW51c2VkLW1hY3JvcykKIHdhcm5pbmctMyA6PSAtV2JhZC1mdW5jdGlv
bi1jYXN0CiB3YXJuaW5nLTMgKz0gLVdjYXN0LXF1YWwKIHdhcm5pbmctMyArPSAtV2NvbnZlcnNp
b24KK3dhcm5pbmctMyArPSAkKGNhbGwgY2Mtb3B0aW9uLCAtV2NvbnN0YW50LWNvbnZlcnNpb24p
CiB3YXJuaW5nLTMgKz0gLVdwYWNrZWQKIHdhcm5pbmctMyArPSAtV3BhZGRlZAogd2FybmluZy0z
ICs9IC1XcG9pbnRlci1hcml0aAotLSAKMi4yMC4xCgo=
--00000000000031a3a8058d788f42
Content-Type: application/x-patch; 
	name="0001-x86-kvm-clang-Disable-Wconstant-conversion-warning.patch"
Content-Disposition: attachment; 
	filename="0001-x86-kvm-clang-Disable-Wconstant-conversion-warning.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jxzw8t6j1>
X-Attachment-Id: f_jxzw8t6j1

RnJvbSBlOTU4YzFiN2IzMzUzMzcyYThmNmRlODdjNTVmZmE5NTM5MjMxNGU2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAY3JlZGF0aXYuZGU+
CkRhdGU6IFR1ZSwgMTkgTWFyIDIwMTkgMjM6Mzk6MzIgKzAxMDAKU3ViamVjdDogW1BBVENIXSB4
ODY6IGt2bTogY2xhbmc6IERpc2FibGUgLVdjb25zdGFudC1jb252ZXJzaW9uIHdhcm5pbmcKCi0t
LQogYXJjaC94ODYva3ZtL01ha2VmaWxlIHwgMSArCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKykKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vTWFrZWZpbGUgYi9hcmNoL3g4Ni9rdm0v
TWFrZWZpbGUKaW5kZXggMzFlY2Y3YTc2ZDVhLi41NGRkNTJjMmU5MjcgMTAwNjQ0Ci0tLSBhL2Fy
Y2gveDg2L2t2bS9NYWtlZmlsZQorKysgYi9hcmNoL3g4Ni9rdm0vTWFrZWZpbGUKQEAgLTEsNiAr
MSw3IEBACiAjIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wCiAKIGNjZmxhZ3MteSAr
PSAtSWFyY2gveDg2L2t2bQorY2NmbGFncy15ICs9ICQoY2FsbCBjYy1kaXNhYmxlLXdhcm5pbmcs
IGNvbnN0YW50LWNvbnZlcnNpb24pCiAKIEtWTSA6PSAuLi8uLi8uLi92aXJ0L2t2bQogCi0tIAoy
LjIwLjEKCg==
--00000000000031a3a8058d788f42--
