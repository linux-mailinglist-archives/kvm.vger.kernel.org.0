Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 257B0440BF
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 18:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391331AbfFMQJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 12:09:05 -0400
Received: from mail-io1-f43.google.com ([209.85.166.43]:33135 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391272AbfFMQJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 12:09:03 -0400
Received: by mail-io1-f43.google.com with SMTP id u13so18149754iop.0
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 09:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iMeJEANEj8ik6IDMErMoEaCSBHIA8g8GzuG2zWtAvlw=;
        b=EHjt3ZF3XDXDFyWbJnLFxaiGfFBHVeiucjhoBZGxg+H83c3kKBvQYLAYWZaG5B7I1P
         x7bl4b/iATUPftdF1GXWvd1J2t+Ic3jMlsKP0Slea1H9Pk3zgFVc4CgTZGCffeXA+iy3
         A1Hv2xeBhaCVoigBrO/40ntTcjyAYecCzWxu54TZDsFV4tlpdwWffJ6UEkf7s+9AGXhf
         /D083CKRJV4vE8/m8j58Ucx6rKyRoI1FWtmFuzcU6pKqr+Gduyg/N4Q1b9WHuFjcVEnn
         gLYkqsBNcVPGp0HmYrJofm/V/cO7aM9G4lOPaLw6foXNtzZLI2XEZtiQ9inTiXQvL9eP
         8aZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iMeJEANEj8ik6IDMErMoEaCSBHIA8g8GzuG2zWtAvlw=;
        b=luvmkYd/hMYZnIwnRh/QSWtB/0I2alN4blK7UMSljOCTX1LhL9sdHA54BZ/QJa7Fuo
         qEfa822/wquo6a1Nn1rYzg2dcLuMzKXnjRbSkC1U6H7szMq4fPYbqOJfLULb6wjZMjQV
         ZkTt8Q5m2EfqCCHcetx+34BkxriL3ZL6lw9XgFaC0YfY/aqev0lvypYnMvbcrW1/jSP5
         wj1rv4oaQ4UNJiLpf/qQ9/G1tpPNfBxtS/aVtLB+65oCQFRGTqR84bU3adGRWWYgzK+z
         roWA3VFrqnMpZgwmgsGpgv4UNKKTnfUimYv0z+uvS5q7stEYuFiq2RrIzCJn46729seN
         vvTg==
X-Gm-Message-State: APjAAAVwwLh5QKOK9Hp2Sp5D3t7hmTcnaRrREuh0gAOK4A2VnHynNaEg
        K1tjXCdrhkImpZpG2AWXNIi956TJzDL5HyH/c3nCcIxJqZo=
X-Google-Smtp-Source: APXvYqzW3hwXyiXchoX1t49evl1vNnee9NVzkIVPjSWhYw6tkX+mFTm5J6xmkKcFuDloSf+rH1l1cNGC7AX+yefIzOc=
X-Received: by 2002:a02:ce50:: with SMTP id y16mr60237263jar.75.1560442142196;
 Thu, 13 Jun 2019 09:09:02 -0700 (PDT)
MIME-Version: 1.0
References: <CALMp9eQ4k71ox=0xQKM+CfOkFe6Vqp+0znJ3Ju4ZmyL9fgjm=w@mail.gmail.com>
 <87d0jhegjj.fsf@vitty.brq.redhat.com>
In-Reply-To: <87d0jhegjj.fsf@vitty.brq.redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 13 Jun 2019 09:08:51 -0700
Message-ID: <CALMp9eTe_iSgn5ihod_B=H1JzXwc_=CW22u+5sQCyPT=EJuLPQ@mail.gmail.com>
Subject: Re: What's with all of the hardcoded instruction lengths in svm.c?
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 13, 2019 at 6:55 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:

> I can try sending a patch removing the manual advancement to see if
> anyone has any objections.

That would be great!

Thanks!
