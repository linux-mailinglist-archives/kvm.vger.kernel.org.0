Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0223CC31A3
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 12:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730462AbfJAKkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 06:40:15 -0400
Received: from mail-oi1-f181.google.com ([209.85.167.181]:36921 "EHLO
        mail-oi1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfJAKkP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 06:40:15 -0400
Received: by mail-oi1-f181.google.com with SMTP id i16so13941390oie.4
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2019 03:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kxIIsHuIPorDlLUxOBDcH6X4UgN2KxPMkflJuW7ONtQ=;
        b=eFcGzOlCZygJlf1p+EEVH4IuViLnoP/QXni8qNyXrUCzENWM7zKKV0FJZmVvW36cxI
         enCUfqhYuBZCVysqXCAOZAvpTWHfXSFcZscNUKL2tBucCiRkxPqyzDXvwN9NP/S01Fty
         qUzZvT9vjnuNQQxyVbgGT4JKhM74KZnXNFPTAOhcEgfRYl6TapZrMtEABkThYrKvKL8w
         fXLmpVcZpaF6t3oH9SqShvx776pSNhxaYf7LGU3jIVM90BgZvA1oerGgX6yqcXA5xUws
         DXcagrNWXVhoV60hCzyEu8GPNKo+DkEr+544xu39bsBw8ky0o8CxjRl3RSDuGf0RYSFW
         lKig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kxIIsHuIPorDlLUxOBDcH6X4UgN2KxPMkflJuW7ONtQ=;
        b=Q52pTx2uvpbH1rqDPHIHMpS6S8DdD2DkZxE3d3gfC2bv2lewMCA920AL1hOP6SwfLp
         m/lGiJAFZ1AJpkgke7jv3XPUEdt0jip4kRanAoU4G9ecTAghDnocsU1EAY0Nz9Qr3JSi
         a3Xj+FF+mu4KIEFWkodGCtuE7o0ISPg5A/4pu3RKwenq1QrZnKmHOT2ytnPpynYMWGjL
         v8jSn9i3yZOdGGiP6zkOyyKX7EJfeiVjUgHyjxcNQrMJNrRCyUyuYwUV69W0LT4O2wV2
         qnC1qgucuuSoQN/ZoidgNwoSK6DahfINOeuP/lA3mBWbHnO+5uQJUYQWWsv0SXrRTsDI
         DXIw==
X-Gm-Message-State: APjAAAVne24M71NubMZ5wNdeEUvm2AeDIh4kx7FrBIloLLFqQLfqo/ic
        hMAwtN/5O14CWK6f1TBTcS5dFLexWfRLX+gXcoCDUQ==
X-Google-Smtp-Source: APXvYqySOn8nL8o0y4pwH2lFYLOib+k1N9rcK2mnv+eOyuVTiX/hfi7lheTIvR0HlFDX3ZizqjA1Hic94Gt94almVWg=
X-Received: by 2002:aca:b48a:: with SMTP id d132mr3210521oif.98.1569926414125;
 Tue, 01 Oct 2019 03:40:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190930131955.101131-1-borntraeger@de.ibm.com>
In-Reply-To: <20190930131955.101131-1-borntraeger@de.ibm.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 1 Oct 2019 11:40:03 +0100
Message-ID: <CAFEAcA8ooDuLxQ8rAFX1K4v3SpKqWO462+wX6pyvmuipZ20+XQ@mail.gmail.com>
Subject: Re: [PULL 00/12] s390x qemu updates 20190930
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>,
        qemu-s390x <qemu-s390x@nongnu.org>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Thomas Huth <thuth@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Collin Walling <walling@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 30 Sep 2019 at 14:20, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
> Peter,
>
> The following changes since commit 786d36ad416c6c199b18b78cc31eddfb784fe15d:
>
>   Merge remote-tracking branch 'remotes/pmaydell/tags/pull-target-arm-20190927' into staging (2019-09-30 11:02:22 +0100)
>
> are available in the Git repository at:
>
>   git://github.com/borntraeger/qemu.git tags/s390x-20190930
>
> for you to fetch changes up to c5b9ce518c0551d0198bcddadc82e03de9ac8de9:
>
>   s390/kvm: split kvm mem slots at 4TB (2019-09-30 13:51:50 +0200)
>
> ----------------------------------------------------------------
> - do not abuse memory_region_allocate_system_memory and split the memory
>   according to KVM memslots in KVM code instead (Paolo, Igor)
> - change splitting to split at 4TB (Christian)
> - do not claim s390 (31bit) support in configure (Thomas)
> - sclp error checking (Janosch, Claudio)
> - new s390 pci maintainer (Matt, Collin)
> - fix s390 pci (again) (Matt)


Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/4.2
for any user-visible changes.

-- PMM
