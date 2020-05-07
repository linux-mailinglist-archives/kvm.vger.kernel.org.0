Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2781C803D
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 05:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgEGDAn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 23:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727106AbgEGDAn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 23:00:43 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB58C061A0F;
        Wed,  6 May 2020 20:00:41 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z8so4511692wrw.3;
        Wed, 06 May 2020 20:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dFNA74RHr/B0YCNDQy2zQLL9WCg7uP2pI8pODcjJZLo=;
        b=UlxwjTXFzumUixnRmqThlCscCI/ihO/R+RyMUmFFw2uw4nEl2xFME5/reioXVMYVkn
         5XWIHrEii4Zi4XhL96HI6CsXMz/j28Jmpy0meWCM6LKC63o6375rgJY19asv928X76QT
         bme/whzo9ZetNBtGc9P8Oq3dVaV9phPmIxo91HhriszxhCnjrgl/YE6IH0UHPnTonnIu
         q14EJUv08FPw/F8gOJVPt+kMwtPT+8N0aZfBvjxxkmeXnEk5UKk/3OBOFljpzV7DU2uM
         jSZuM+Oym3crPGMDwEPXrlvtfwjIHDdelsfnTBw8lqMzsEbov1k5ikq8y3JFDIuxQzre
         UEXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dFNA74RHr/B0YCNDQy2zQLL9WCg7uP2pI8pODcjJZLo=;
        b=Z0NQnobG7qpCpIi8yoKenbTz1RWW4jKlKwlVT7vVgHHhCiCl5GjNGYAbkNlNbGc49k
         OzGJST/giYiCt329x4nq63nJH9vxdId889h2NYbX95UY6XRFP1Vzcp/AWn8pXx2aNHJz
         4ovYUFGrclLEr115+FdEVOBmYWEhhvqOcqlwW83HxDrCq9k7RNGHH/tTlR/JQ0YnqzyP
         QXYIEyEb2C1JTCrBAYcs0AnY3C1aHdSF3QwFGSK4YGjodwxq7hOj5Re/VevkqXyAFdt4
         vUNMvaEUQgJQWJR6GIF2q14o1HswXB/RildTYH7XvTy89rBkWc+CRkAsNnLTNh0+z2ZU
         3+bQ==
X-Gm-Message-State: AGi0PuZjS1HiyJxWv/u9oLXVSCmc5rKFn9XDhV/Y1Fzv2T/7S7163bRp
        M3RLO27Kyhpv/RFNV3nS9S0=
X-Google-Smtp-Source: APiQypJ8ZcAF8AaoB8LwzngzBV9iAUwVjSPCJy3LJFKEGWxbq2DYqV/sWcyulbcEEL0i0zhcS+7CWg==
X-Received: by 2002:adf:c38c:: with SMTP id p12mr13613055wrf.357.1588820439856;
        Wed, 06 May 2020 20:00:39 -0700 (PDT)
Received: from jondnuc (IGLD-84-229-154-20.inter.net.il. [84.229.154.20])
        by smtp.gmail.com with ESMTPSA id s11sm5492525wrp.79.2020.05.06.20.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 20:00:39 -0700 (PDT)
Date:   Thu, 7 May 2020 06:00:37 +0300
From:   Jon Doron <arilou@gmail.com>
To:     Roman Kagan <rvkagan@yandex-team.ru>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v2 0/1] x86/kvm/hyper-v: Add support to SYNIC exit on EOM
Message-ID: <20200507030037.GE2862@jondnuc>
References: <20200418064127.GB1917435@jondnuc>
 <20200424133742.GA2439920@rvkaganb>
 <20200425061637.GF1917435@jondnuc>
 <20200503191900.GA389956@rvkaganb>
 <87a72nelup.fsf@vitty.brq.redhat.com>
 <20200505080158.GA400685@rvkaganb>
 <20200505103821.GB2862@jondnuc>
 <20200505200010.GB400685@rvkaganb>
 <20200506044929.GD2862@jondnuc>
 <20200506084615.GA32841@rvkaganb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200506084615.GA32841@rvkaganb>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/2020, Roman Kagan wrote:
>On Wed, May 06, 2020 at 07:49:29AM +0300, Jon Doron wrote:
>> Thanks Roman, I see your point, it's important for me to get the EDK2
>> working properly not sure why it's not working for me.
>
>As I wrote a good deal of that code I hope I should be able to help (and
>I'd be interested, too).  How exactly does the "not working" look like?
>

Basically when I built the BIOS from the hv-scsi branch you pointed me 
out to, the BIOS did not see the virtio-blk device to boot from, I 
usually take the BIOS from (https://www.kraxel.org/repos/) but I will 
try to build the latest EDK2 and see if it identifies the virtio-blk 
device and boots from it, if that's the case perhaps i just need to 
rebase your branch over the latest master of EDK2.

>Also I'm a bit confused as to why UEFI is critical for the work you're
>doing?  Can't it be made to work with BIOS first?
>

The reason I want to have the UEFI option is because I need SecureBoot 
to turn on VBS.

>> Do you know by any chance if the EDK2 hyperv patches were submitted and if
>> they were why they were not merged in?
>
>I do, as I'm probably the only one who could have submitted them :)
>
>No they were not submitted.  Neither were the ones for SeaBIOS nor iPXE.
>The reason was that I had found no way to use alternative firmware with
>HyperV, so the only environment where that would be useful and testable
>was QEMU with VMBus.  Therefore I thought it made no sense to submit
>them until VMBus landed in QEMU.
>
>Thanks,
>Roman.

Heh I see, well I'm really happy that you are here helping so we can try 
and finally add VMBus to QEMU, I realize it's a big effort but I'm 
willing to spend the time and do the required changes...

I'm working this only during my free time so things takes me longer than 
usual (sorry for that..)

I will keep update on results once I get to test with latest EDK2 :) 

Thanks,
-- Jon.
