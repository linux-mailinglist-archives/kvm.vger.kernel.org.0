Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF151ACE3E
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 19:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390454AbgDPRCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 13:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387757AbgDPRCK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 13:02:10 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874BAC061A0F
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 10:02:10 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id r7so8558985ljg.13
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 10:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dDes2+uYwqdDpp6u8TFEa/zLM2coaSYzbk9Klu5JF50=;
        b=d4bGcI6r9EXx896lm5psS0z1tGPVAD1Aq/Ppvu5hGlzAbh+Zf/1v3KrwUBex7wJOqX
         fdBbg7Y0d06giLFwxcJ/M+yzoOCnSc92Ma3Vx8FQSeIFEJ9t0tWAkPjyb2FW9WP2SOBk
         +rtsc0ysltydTupDTjzTBovmcsnwzBPYrog24=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dDes2+uYwqdDpp6u8TFEa/zLM2coaSYzbk9Klu5JF50=;
        b=Ln6oujm2hQTbjXhdsUTfSDw+12lolGO+nVanhcVNijZBHOTVjg+oYZq9vzIIHrHO5m
         c+2daaB4Xz6t0jojvgPJIx+krpA3ZQV96IMd2uPx9cHmy+TVAyEh57ypmX7pgunuIppQ
         w4zkwcwh2xllaoMj3oia3XheotJ69sR8v8f0ZIRuHmJVfj6VXFx6AeFueDFFWATCwDbA
         rJEuORIbdoltjRJrZ/6QZ6p9URpLv/Rsb8XMUlyI6ZXgmtYPoQCQFY7ozhPRvoY88NPr
         kWInXyhBJoC89o23aJWJTrnMMWDTlzXJQ+ZvxlLJrscGRofVtjiPtCNfvdXAtbandUWi
         889Q==
X-Gm-Message-State: AGi0Puaat5A8xBOXaj8xEn4VM9VRlrJQSqtlXIY/kUZYVDmxA67Rz/0l
        a8IbPswJYdhZ1WiZmkGn6MexFHd1PFs=
X-Google-Smtp-Source: APiQypJ58uspzGAIr73jblarzj0LwVSIUR1ceS+LFSM/2s+ScAmhWVKSpyg9gZaSx/y03PXYWP5AGg==
X-Received: by 2002:a2e:b0ee:: with SMTP id h14mr7228977ljl.35.1587056529044;
        Thu, 16 Apr 2020 10:02:09 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id x29sm15840392lfn.64.2020.04.16.10.02.08
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 10:02:08 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id u15so8642869ljd.3
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 10:02:08 -0700 (PDT)
X-Received: by 2002:a2e:7c1a:: with SMTP id x26mr6539997ljc.209.1587056528034;
 Thu, 16 Apr 2020 10:02:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200414123606-mutt-send-email-mst@kernel.org>
 <CAHk-=wgVQcD=JJVmowEorHHQSVmSw+vG+Ddc4FATZoTp9mfUmw@mail.gmail.com> <20200416081330-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200416081330-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 16 Apr 2020 10:01:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjduPCAE-sr_XLUdExupiL0bOU5GBfpMd32cqMC-VVxeg@mail.gmail.com>
Message-ID: <CAHk-=wjduPCAE-sr_XLUdExupiL0bOU5GBfpMd32cqMC-VVxeg@mail.gmail.com>
Subject: Re: [GIT PULL] vhost: cleanups and fixes
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, ashutosh.dixit@intel.com,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Markus Elfring <elfring@users.sourceforge.net>,
        eli@mellanox.com, eperezma@redhat.com,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>, hulkci@huawei.com,
        "Cc: stable@vger.kernel.org, david@redhat.com, dverkamp@chromium.org,
        hch@lst.de, jasowang@redhat.com, liang.z.li@intel.com, mst@redhat.com,
        tiny.windzz@gmail.com," <jasowang@redhat.com>,
        matej.genci@nutanix.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        yanaijie@huawei.com, YueHaibing <yuehaibing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 16, 2020 at 5:20 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> Well it's all just fallout from

What? No. Half of it seems to be the moving of "struct vring" around
to other headers and stuff.

And then that is done very confusingly too, using two different
structures both called "struct vring".

No way can I pull that kind of craziness as a "fix".

                Linus
