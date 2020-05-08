Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBE01CB1D3
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 16:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgEHO36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 10:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726873AbgEHO35 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 10:29:57 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83471C05BD43;
        Fri,  8 May 2020 07:29:57 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z8so2155593wrw.3;
        Fri, 08 May 2020 07:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2+2RrQGnTFUDHo1nQ+eoI91mES5cwFOLmSedeSlm/AU=;
        b=kO/BTSbr2v4J2zrxepOmL3FGrXq4Lncu493CrzjLaqUMozqba70YjROg0oyHLMBqDg
         yZWQodqA4QAnPk5z7FAnHCSL8jDeQS58n7dw3J4/hx4Jzi0Ma6M/qh41faBZUhPZFKXq
         ZWsX+kMOhad4vcnlfnz8/iUXTPw6/Cn218jJ/MQPHretKZ95c36IiNxMqW3zSMNNZkhO
         XnW66AFEhdNAPSjkBwMYpMJTECzW9pkLxGRG1zWEMTQ1fvkD7dH4JTUBNfs7j9PJ6A1k
         tmOVMQ1GJRA9EUaIUaVrUgnkmNFg8kiP9sbOU8LKas7YUa8YLLvYhm2V7GiFTwMnxPjt
         cpcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2+2RrQGnTFUDHo1nQ+eoI91mES5cwFOLmSedeSlm/AU=;
        b=QwhnQVIcLtsCx+fokNYmenQwZ7xPkv/ArHUQxFklm7k1Bu5jMUwgTCc6gfMSXMNmmi
         dnaDhx+smQoWnWYDILaeueaUKo03y+GrF7EboDxLXw6QQHOLUfwnIgC6b69bhPsT+/iH
         6FXL/bzE5s+ke2uzJj6OzEJQgirwWFLhPAf5KXcdFPyCEmCGrtXoc5FlXCJWrmh4g36B
         5D76v02JFppYal3zbQUm9vSGu0p7RdgrynDJ3zPryxnU47pNAagFxUfFm8ySQ55AHaZP
         fo8tiAJWQdKM2mAYajv6UBVWgulNJ/7oxnzO4K3M/55LP2lQ2P6UH4SJ7mXRMXBQ0V++
         0qfg==
X-Gm-Message-State: AGi0PuYKk7eTibwBkCx9nNR3bsu3UPdVDu1zQR2yCyB/CnDwnd6IZp87
        5dtwJ0k8fozxsoVmh0EiDSCVg+/WfwU=
X-Google-Smtp-Source: APiQypKRq/86ukxOi4pyRK4Wppqzwc6rxIoOmYILWTYPYbRx5S2g/b+6xIw4Xm9krjGsih4ey/mrQA==
X-Received: by 2002:a5d:5682:: with SMTP id f2mr3192542wrv.382.1588948196243;
        Fri, 08 May 2020 07:29:56 -0700 (PDT)
Received: from jondnuc (IGLD-84-229-154-20.inter.net.il. [84.229.154.20])
        by smtp.gmail.com with ESMTPSA id r23sm3746563wra.74.2020.05.08.07.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 07:29:55 -0700 (PDT)
Date:   Fri, 8 May 2020 17:29:54 +0300
From:   Jon Doron <arilou@gmail.com>
To:     Roman Kagan <rvkagan@yandex-team.ru>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v2 0/1] x86/kvm/hyper-v: Add support to SYNIC exit on EOM
Message-ID: <20200508142954.GH2862@jondnuc>
References: <20200424133742.GA2439920@rvkaganb>
 <20200425061637.GF1917435@jondnuc>
 <20200503191900.GA389956@rvkaganb>
 <87a72nelup.fsf@vitty.brq.redhat.com>
 <20200505080158.GA400685@rvkaganb>
 <20200505103821.GB2862@jondnuc>
 <20200505200010.GB400685@rvkaganb>
 <20200506044929.GD2862@jondnuc>
 <20200506084615.GA32841@rvkaganb>
 <20200507030037.GE2862@jondnuc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200507030037.GE2862@jondnuc>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/2020, Jon Doron wrote:
>On 06/05/2020, Roman Kagan wrote:
>>On Wed, May 06, 2020 at 07:49:29AM +0300, Jon Doron wrote:
>>>Thanks Roman, I see your point, it's important for me to get the EDK2
>>>working properly not sure why it's not working for me.
>>
>>As I wrote a good deal of that code I hope I should be able to help (and
>>I'd be interested, too).  How exactly does the "not working" look like?
>>
>
>Basically when I built the BIOS from the hv-scsi branch you pointed me 
>out to, the BIOS did not see the virtio-blk device to boot from, I 
>usually take the BIOS from (https://www.kraxel.org/repos/) but I will 
>try to build the latest EDK2 and see if it identifies the virtio-blk 
>device and boots from it, if that's the case perhaps i just need to 
>rebase your branch over the latest master of EDK2.
>
>>Also I'm a bit confused as to why UEFI is critical for the work you're
>>doing?  Can't it be made to work with BIOS first?
>>
>
>The reason I want to have the UEFI option is because I need SecureBoot 
>to turn on VBS.
>
>>>Do you know by any chance if the EDK2 hyperv patches were submitted and if
>>>they were why they were not merged in?
>>
>>I do, as I'm probably the only one who could have submitted them :)
>>
>>No they were not submitted.  Neither were the ones for SeaBIOS nor iPXE.
>>The reason was that I had found no way to use alternative firmware with
>>HyperV, so the only environment where that would be useful and testable
>>was QEMU with VMBus.  Therefore I thought it made no sense to submit
>>them until VMBus landed in QEMU.
>>
>>Thanks,
>>Roman.
>
>Heh I see, well I'm really happy that you are here helping so we can 
>try and finally add VMBus to QEMU, I realize it's a big effort but I'm 
>willing to spend the time and do the required changes...
>
>I'm working this only during my free time so things takes me longer 
>than usual (sorry for that..)
>
>I will keep update on results once I get to test with latest EDK2 :)
>
>Thanks,
>-- Jon.

Hi, just wanted to update you I did some stupid mistake when I did the 
UEFI setup test (that's why I could not boot my Win10).

I suggest we will abandon this patch, and try to keep going on the QEMU 
VMBus patchset.

And perhaps submit a very basic patch to SeaBIOS and EDK2 which just 
enable SCONTROL.

Does that sound like a good plan to you?

Thanks,
-- Jon.
