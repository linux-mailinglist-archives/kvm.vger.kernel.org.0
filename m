Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55823EA1F6
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 11:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235668AbhHLJXI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 05:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236098AbhHLJXE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 05:23:04 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14006C061798
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 02:22:40 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id h11so9439325oie.0
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 02:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ow8pOCC7Pfffi05timzyvoLwa6w/ZcLDyaYIxhtLEXc=;
        b=BEnTTEkeoRG+ar6fm5BoupukkxVmIStsqg6p9X1L2YewdIyTkSQj1WN+P6+otJ0++C
         OtX9opzFHCsNib5ayBH3jRJZa30tRdmfcDXAgnJh9+DmlgcpBNLpFCd4UVvvzyfris/w
         nnstb7QJaX4Qdo8LEROO46qPuYSm8vYSv/psYVhvHn+iUtQmSXiiWUPmR/0m+vfmnoH3
         KK7LL5G5h8tKWRidLASXmAOKd1dXuJ8aXoPGuJiKY1l7gqxEI7DbdTfujtppYtzNT+9H
         qzhuzhUZqiCR/wo61T46BUT+5gIQQtGg0xW9QMFzqKarfdR6aBTXX1cMQt3qlC1dttYd
         a7VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ow8pOCC7Pfffi05timzyvoLwa6w/ZcLDyaYIxhtLEXc=;
        b=Vph29z1diPceWTa6pLqc1CQYDis3EYR9/iwpyoHYho0JBJznXuI7uYJjXRtwoHcqTN
         Pug8+wdkC8pnKdmOLb6VrjOvft+WAH4qU/lbo6GVxBbZgrclRBhoH2VDa1Q8ug8hxvbj
         FdTHGsCVatNl2olG2BaZWIBVeQ36pp9tinP7POBwBIhjg8RkbTSUq8IBhdbSn1+/dzXz
         9o9L9hmzmsUd1bOZamoL0qbZknZFhdt1dsHg024BK6+zObXY0g5SyvSlnBPo0+6SKk9p
         IvMrsDo2dDMMZTyDTWCY93IfPTQq3KX+tNNbWRAIG/+XlF9uS0xupDBrNirUKSrPtUmP
         wniw==
X-Gm-Message-State: AOAM5307xyyfdtBdl8lZtnqKkp98laxfBxy1ic4cmYOVHKW2KuyVYy2l
        5J1ybzNWPwFg7oeCBbSBEDZGom8RWWXgTJqAXiNJBA==
X-Google-Smtp-Source: ABdhPJyKVto4075gxkTTsWk/Og0Ua476G6PD6Md0kKz1KwdQr50M8mhKFW7wA41+P4p5DR5rb+t8mWsbdIpVjfh3lzI=
X-Received: by 2002:aca:220a:: with SMTP id b10mr10613392oic.8.1628760159300;
 Thu, 12 Aug 2021 02:22:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com> <20210719160346.609914-2-tabba@google.com>
 <20210812085857.GB5912@willie-the-truck>
In-Reply-To: <20210812085857.GB5912@willie-the-truck>
From:   Fuad Tabba <tabba@google.com>
Date:   Thu, 12 Aug 2021 11:22:03 +0200
Message-ID: <CA+EHjTx++8neadZ=i5Gu-mCeZFC=CBLJ4bd_=QefBoHBb5Qe9Q@mail.gmail.com>
Subject: Re: [PATCH v3 01/15] KVM: arm64: placeholder to check if VM is protected
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,


On Thu, Aug 12, 2021 at 10:59 AM Will Deacon <will@kernel.org> wrote:
>
> On Mon, Jul 19, 2021 at 05:03:32PM +0100, Fuad Tabba wrote:
> > Add a function to check whether a VM is protected (under pKVM).
> > Since the creation of protected VMs isn't enabled yet, this is a
> > placeholder that always returns false. The intention is for this
> > to become a check for protected VMs in the future (see Will's RFC
> > [*]).
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> >
> > [*] https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/
>
> You can make this a Link: tag.

Of course. Thanks!
/fuad
> Anyway, I think it makes lots of sense to decouple this from the user-ABI
> series:
>
> Acked-by: Will Deacon <will@kernel.org>
>
> Will
