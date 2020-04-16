Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6011AB4DD
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 02:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404924AbgDPAq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 20:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404680AbgDPAqx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 20:46:53 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72F8C061A0C
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 17:46:52 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id u6so4323400ljl.6
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 17:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hzMDorCv1GZID9zsmGcg6OddhqYx722MVsuJ8PCoquU=;
        b=PQbQU4mx+Y47Kp0VmJmY4pdmkyIFeOBpm/PuEBSauBtddR5AErvLkCUxYdB5QBq+Bl
         hkSP5lJlqOjR6sKAAc+32Cg2e5kqRXpCMz9orUD/QAFTm2fIM2IpvXHQkVIn6FAEqQOR
         he4mBko7bQTN6Ponzq1pQyRnUmWxWkRdsyIqM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hzMDorCv1GZID9zsmGcg6OddhqYx722MVsuJ8PCoquU=;
        b=as/U9jk2y7V/ejqQxIduA4VFRRAR495MjiNeZ6rX/pggPMGn95R7YXUOBUzK8zF2x3
         rR1PQqrNQNQdKmHBe44AOgYvqpIFJH8iNWGaUtjT56/xnlrhYFm+MLTS6lRyf9uJW9SY
         /XXy9gqbzECmM/NHMzyT3OQ4fmiq08e+DHDSB1OmfV8nHQOkp2rZrP5zJAR0k3G7htkA
         xh+A3W+paUURYdjINjHbxQG/pl4UDMExXXwIf/L/4jPp3IhLW6/wJnlpk4e8alZ57vWl
         mWdkDws8vnXY/MoOaX73SBaY8ku0uiDYLHtHReg35X86dPeX9w6CaBmfQcz4ysgkzpLk
         CK0w==
X-Gm-Message-State: AGi0PuYsbTENjjn/KhSY8GO9vL0hGb1px9ZqZ7r200tEKOx79S46rv4Q
        EK6a2rLvVOk7AjfNvuYlzqcl35fpzbU=
X-Google-Smtp-Source: APiQypKwqvc0GeF+2PITHio3fNwff77BDTMNv/pYyAZXehu79/86v/kXpGLiW41Fx5e7gi4ZmTHJTw==
X-Received: by 2002:a2e:80c1:: with SMTP id r1mr4518737ljg.227.1586998010674;
        Wed, 15 Apr 2020 17:46:50 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id c4sm13857940lfg.82.2020.04.15.17.46.49
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 17:46:49 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id v9so5873805ljk.12
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 17:46:49 -0700 (PDT)
X-Received: by 2002:a2e:870f:: with SMTP id m15mr4867889lji.16.1586998009252;
 Wed, 15 Apr 2020 17:46:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200414123606-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200414123606-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 15 Apr 2020 17:46:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgVQcD=JJVmowEorHHQSVmSw+vG+Ddc4FATZoTp9mfUmw@mail.gmail.com>
Message-ID: <CAHk-=wgVQcD=JJVmowEorHHQSVmSw+vG+Ddc4FATZoTp9mfUmw@mail.gmail.com>
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

On Tue, Apr 14, 2020 at 9:36 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> virtio: fixes, cleanups

Looking at this, about 75% of it looks like it should have come in
during the merge window, not now.

              Linus
