Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4606C7A671
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 13:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbfG3LEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 07:04:09 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54017 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfG3LEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 07:04:09 -0400
Received: by mail-wm1-f65.google.com with SMTP id x15so56738802wmj.3
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 04:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kAaSPn1SAnhMdouNiZFncd+kh2nGtT7o+fO0/xriDJM=;
        b=rtURJ5tjTGQezYchXptus1tZePK5IushptflcrP+I4zOEDOzawXa8lEWlpLTyABP05
         WcvP42levCh9WFweBkXwjLV1O5gjaYCtAwo+LxmXtdams5440uB9Au+0IOqlvgvCQDox
         0QOqGc7cZaSYRFIthov7WGk9xFRrfQ0yCDdK0rjX6zdeViKjkIRWrKXe9a22hTtEjF5w
         KGjWactDJtFahKEJAaqTgK/W8UYIa3JZ9O0X+MmpSKu+T2/MtMpStwlLkpTtXNhqkvZn
         rOUJC9iwH8FJ0XRoZsS1uEXPEwUTIwGTrq2+SSYaj9QV4vsq0oNdAjo25MqtWEk3+RUF
         80Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kAaSPn1SAnhMdouNiZFncd+kh2nGtT7o+fO0/xriDJM=;
        b=PKpVEZuhMWWLoSSdSGjZu5n0qjSBKBcu081dIxrY4DZ5z52uk21hgtXXj5iqoqRH1u
         P46kglIunQJjDf3IAlSOt38RrnFNqylcICOboRh/mR3BD0WPXLDNa8x8RL7sX0ULu//x
         6zjX8rzM2g7Gvp09bU8udCjbWqmm8HJVKjiS09Rn8ClbwmKg+yId9JRfYBbJ4w9S13ru
         mbfRdFkdzbh3fQ5u2g3naqT/IEOIeQbwp+ey4uD5entGze1PtVZ8ia1k0X45nqdsZWrr
         o27PiBhY88ONcSlNWIRb6Qo/cYCvn1GPrI/ybKxHgnXIAimFXJxjwdwbHzVzYECUkpuG
         vS2w==
X-Gm-Message-State: APjAAAWXmieXgRQoHzh2C9Nim04+DYUlk5Z3V6G0tLqcpFCRYNKsKH2t
        wlvw7HB22LCKaskMdTWPuNYjAAlW7PQoHvEkb5Q=
X-Google-Smtp-Source: APXvYqyCdoUNtlHs7orkEBhS8EG9A8IbKL4dk2VepkFVzYAN9ZWH2nTWL3pZtJ3WiTvF6eb5BbRHk5ldhvDUkb7rXyU=
X-Received: by 2002:a05:600c:254b:: with SMTP id e11mr97733084wma.171.1564484646738;
 Tue, 30 Jul 2019 04:04:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190729115544.17895-1-anup.patel@wdc.com> <20190729115544.17895-4-anup.patel@wdc.com>
 <d1157450-258b-91c1-72cb-867c96f929d8@redhat.com>
In-Reply-To: <d1157450-258b-91c1-72cb-867c96f929d8@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 30 Jul 2019 16:33:55 +0530
Message-ID: <CAAhSdy3n5DBKZ-_Vq39wYvbQ5iLYvdB2gXctkh+NuhynWzQJzQ@mail.gmail.com>
Subject: Re: [RFC PATCH 03/16] RISC-V: Add initial skeletal KVM support
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 30, 2019 at 2:55 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 29/07/19 13:56, Anup Patel wrote:
> > +void kvm_riscv_halt_guest(struct kvm *kvm)
> > +{
> > +     int i;
> > +     struct kvm_vcpu *vcpu;
> > +
> > +     kvm_for_each_vcpu(i, vcpu, kvm)
> > +             vcpu->arch.pause = true;
> > +     kvm_make_all_cpus_request(kvm, KVM_REQ_SLEEP);
> > +}
> > +
> > +void kvm_riscv_resume_guest(struct kvm *kvm)
> > +{
> > +     int i;
> > +     struct kvm_vcpu *vcpu;
> > +
> > +     kvm_for_each_vcpu(i, vcpu, kvm) {
> > +             vcpu->arch.pause = false;
> > +             swake_up_one(kvm_arch_vcpu_wq(vcpu));
> > +     }
>
> Are these unused?  (Perhaps I'm just blind :))

Not used as of now.

The intention was to have APIs for freezing/unfreezing Guest
which can be used to do some work which is atomic from
Guest perspective.

I will remove it and add it back when required.

Regards,
Anup
