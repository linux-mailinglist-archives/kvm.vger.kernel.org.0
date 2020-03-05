Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA96217A943
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 16:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgCEPxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 10:53:05 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36174 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgCEPxF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 10:53:05 -0500
Received: by mail-ed1-f66.google.com with SMTP id a13so7381594edh.3;
        Thu, 05 Mar 2020 07:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3zIiGhH+NqmE7D/rwhoTLyBEtxi9COUeHYXpd/hp1CE=;
        b=aZJzvWCWgRJfr0UAAAp8ALdatMHZYNcUf24/7AvkBxIpMmg/Vt3zZ+hIslR95vw7yE
         4DH/awMqykAuZjTN4y/xadcR7pqPZ+1Pt15ZZcmYe3Mnb0M5LXkTGvrbHNjDpRjw6xnj
         Ar1tYwMM/DIprR+8IBTEY9vaxcM0SIuuLTLedma5trmntQEOvqcDGKwG0FTFM6MwzRi8
         SXkSwony4IkaPpQFan1z79Eu+ljWL0oW8OJOjTaKO8Aj4rfmy3EoHAJTCaaY6oUDpH1G
         T0y9YnAG1K1YeeDdXzEnrCNvtkX7gihcGmwIE9/1Ip1Vq+tyUCI9rxAKYivs2hwfK99Y
         CUcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3zIiGhH+NqmE7D/rwhoTLyBEtxi9COUeHYXpd/hp1CE=;
        b=UejN4mYdbzdl+W3Uk6uxRIExv0k9Clg1aBwATTepz4T+PdQjy1DJAfgIWvkBnV2hsQ
         V1gqD543UZP5qeKZCZSDv9Jpw0aTCle8GTcFxY/ueN3GlaSDfaFfSezjqZHKFXRDe5pT
         dfdkJM7eUJ44dZZerUtjChrxeu8Kz/I4sOw+Nf9tQ+mZsp9Gp9YzrQcbiq5J7DWN19fE
         a1bUagSzq3i2OAK8eYzTO8DYkew+/Xdlis6NcN43WpsSYsNFVv8jqYINlap1RrLrTJGN
         Vd84crdLKsBBVw6rsIpJgxGtqBb2yVUP/0yQVztrw3gibG2WsKzt0dNTowyTsZ0saVTP
         iuvQ==
X-Gm-Message-State: ANhLgQ0Yx6W/mGCuL3KqvI7oH92WoMMtrUDGzwlANmFiOVs3UyXh76vu
        WQBfx4B+pnDuBVQlp7KWfc7U7rGUEd8n5KKe3SE=
X-Google-Smtp-Source: ADFU+vsJmunqbD1mxkWHF1rP8ZNtmvdVnSbe313PRCmTXVVPaS9SFpCUWqScEvEO8aK2BqSBQQ1jocR7n38FuAiwqtw=
X-Received: by 2002:a50:a419:: with SMTP id u25mr7304324edb.289.1583423584002;
 Thu, 05 Mar 2020 07:53:04 -0800 (PST)
MIME-Version: 1.0
References: <20200305140142.413220-1-arilou@gmail.com> <20200305140142.413220-2-arilou@gmail.com>
 <09762184-9913-d334-0a33-b76d153bc371@redhat.com> <CAP7QCoj9=mZCWdiOa92QP9Fjb=p3DfKTs0xHKZYQ+yRiMabmLA@mail.gmail.com>
 <0edfee0e-01ee-bb62-5fc5-67d7d45ec192@redhat.com>
In-Reply-To: <0edfee0e-01ee-bb62-5fc5-67d7d45ec192@redhat.com>
From:   Jon Doron <arilou@gmail.com>
Date:   Thu, 5 Mar 2020 17:52:52 +0200
Message-ID: <CAP7QCogGkC_wOPuuz2cZDb0aRv0GzMGDR2Y0voU8w4hdtO39BQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] x86/kvm/hyper-v: Align the hcall param for kvm_hyperv_exit
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

bah you are right sorry :( but if ill do that ill break userspace no?
-- Jon..

On Thu, Mar 5, 2020 at 5:30 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 05/03/20 15:53, Jon Doron wrote:
> > Vitaly recommended we will align the struct to 64bit...
>
> Oh, then I think you actually should add a padding after "__u32 type;"
> and "__u32 msr;" if you want to make it explicit.  The patch, as is, is
> not aligning anything, hence my confusion.
>
> Thanks,
>
> Paolo
>
> > On Thu, Mar 5, 2020 at 4:24 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 05/03/20 15:01, Jon Doron wrote:
> >>> Signed-off-by: Jon Doron <arilou@gmail.com>
> >>> ---
> >>>  include/uapi/linux/kvm.h | 1 +
> >>>  1 file changed, 1 insertion(+)
> >>>
> >>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> >>> index 4b95f9a31a2f..9b4d449f4d20 100644
> >>> --- a/include/uapi/linux/kvm.h
> >>> +++ b/include/uapi/linux/kvm.h
> >>> @@ -200,6 +200,7 @@ struct kvm_hyperv_exit {
> >>>                       __u64 input;
> >>>                       __u64 result;
> >>>                       __u64 params[2];
> >>> +                     __u32 pad;
> >>>               } hcall;
> >>>       } u;
> >>>  };
> >>>
> >>
> >> Can you explain the purpose of this patch?
> >>
> >> Paolo
> >>
> >
>
