Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD1319797E
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729321AbgC3Kn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:43:58 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:37954 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728912AbgC3Kn6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:43:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585565036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uSoKtGLA69yDQFbn3qP90xq4msstlg1oaukJAsPydnk=;
        b=BSj/sTwxgjBHmrJtA1vxwS2aV2voeBqaGUtRvqmWb9si6w40osp+du9lvF9n8Sla7LMx1/
        BepNs9KtffeUNdXh+OXXPVvmQ9o7ijYHCaV/ywOMEczNBg1m7aAJxRm1YoOgsyVryQAHvf
        A9sedYgGsVT36qW59wrdOWAoqZLKFWo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-r-EyGa54OZiQU_r9XB2qeg-1; Mon, 30 Mar 2020 06:43:55 -0400
X-MC-Unique: r-EyGa54OZiQU_r9XB2qeg-1
Received: by mail-wm1-f72.google.com with SMTP id p18so8585403wmk.9
        for <kvm@vger.kernel.org>; Mon, 30 Mar 2020 03:43:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uSoKtGLA69yDQFbn3qP90xq4msstlg1oaukJAsPydnk=;
        b=VDyV142TI1pEykD43GK1FKca69FLi0FbTAl6bu5Kexah+8N9AxyjNjhTg79XvUHj+1
         ePT1gwNMoBStXYu3K8m8ACh4wBbVcdK7Lj2MtFhxvtZlB+mEe9qjV/SFAOYRCjEtbGuF
         OCfXEChjvuTYngio8UT45w+W+o99LiKau9r/ZlB9aE+eIIOo/j0rvpoBtR2sPmU5Wh64
         ek7A2N60pI7hog/7yB8h3ZFZWgJcztXaPW3BxsFeWwgclBDb7VJuAnSPu5oMIqvdd8Da
         NIsf5HTrgRnGl7YJnmhbd3phxwQY4bE85KlsfnbSOO6wD7RxBxheBzq7C7T6aovKq9da
         Mi0g==
X-Gm-Message-State: ANhLgQ0XJC5WiFTbJ3F4Tp8RC/H2DSCQCseyNtU/RB517azx84pO7qDa
        +3YSS443xvaSKKcqYuXUrejBwd+6e0P6wL7vEaFHO/xeEdKIrA1XDudJTVo1un00Yl34nU3jVXz
        B3zPNK276a6a8
X-Received: by 2002:a1c:b686:: with SMTP id g128mr12459271wmf.75.1585565034096;
        Mon, 30 Mar 2020 03:43:54 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuhAYInQDizjam39UKoJn6IMG7echrdOB53N4zbqPS8G3jt582mrcbhiF/wVklzdiwJyg6Sjg==
X-Received: by 2002:a1c:b686:: with SMTP id g128mr12459243wmf.75.1585565033700;
        Mon, 30 Mar 2020 03:43:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b55d:5ed2:8a41:41ea? ([2001:b07:6468:f312:b55d:5ed2:8a41:41ea])
        by smtp.gmail.com with ESMTPSA id d206sm20701884wmf.29.2020.03.30.03.43.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2020 03:43:53 -0700 (PDT)
Subject: Re: [PATCH 0/7] tools/kvm_stat: add logfile support
To:     Stefan Raspl <raspl@linux.ibm.com>, kvm@vger.kernel.org
References: <20200306114250.57585-1-raspl@linux.ibm.com>
 <7f396df1-9589-6dd0-0adf-af4376aa8314@redhat.com>
 <d893c37d-705c-b9a1-cf98-db997edf3bce@linux.ibm.com>
 <5c350f55-64be-43fc-237d-7f71b4e9afdc@redhat.com>
 <7c8b614a-a7a1-d33e-8762-b06d4b2fd45b@linux.ibm.com>
 <d0143786-04e5-a9f8-bd87-d4c06cee1856@redhat.com>
 <cb983917-2c40-5002-b001-093f25e199a2@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <341997c9-7bda-c699-3a85-8f98e4500dbe@redhat.com>
Date:   Mon, 30 Mar 2020 12:43:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <cb983917-2c40-5002-b001-093f25e199a2@linux.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/03/20 13:22, Stefan Raspl wrote:
> I wrote a respective patch and tried it out, and found this approach not to be
> workable for a number of reasons:
> - The implicit buffering that takes place when redirecting output of kvm_stat in
>   logging mode to a file messes up the format: logrotate moves the files on the
>   disks, but there might be still data buffered that hasn't been written out
>   yet. The SIGHUP triggers a new header to be written with the patch I came up
>   with, but that header would sometimes appear only after a couple of lines
>   written to the file, which messes up the format. Flushing stdout in the signal
>   handler won't help, either - it's already too late by then.

I don't understand this.  Unless you were using copytruncate, the
sequence should be:

- logrotate moves file A to B

- your file descriptor should point to B, so kvm_stat keeps writing to
file B

- you send the signal to kvm_stat

- kvm_stat closes file B, so all pending records are written

- kvm_stat reopens file A and writes the header.

If you have a race of some sort, try having the signal handler do
nothing but set a flag that is examined in the main loop.

> - When restarting kvm_stat logging (e.g. after a reboot), appending to an
>   existing file should suppress a new header from being written, or it would end
>   up somewhere in the middle of the file, messing up the format. kvm_stat
>   doesn't know that or where its output is redirected to, so no chance of
>   suppressing it within kvm_stat. We would probably require some kind of wrapper
>   script (and possibly an extra cmd-line option to suppress the header on
>   start).

You could stat the output file, and suppress the header if it is a
regular non-empty file.  But it would be a problem anyway if the header
has changed since the last boot, which prompts the stupid and lazy
question: how does your series deal with this?

This one seems the biggest of the three problems to me.

> - I was surprised to realize that SIGHUP is actually not part of logrotate -
>   one has to write that manually into the logrotate config as a postrotate...
>   and I'll openly admit that writing a respective killall-command that aims at a
>   python script doesn't seem to be trivial...

This one is easy, put "ExecReload=/bin/kill -HUP $MAINPID" in the
systemd unit and use "systemctl reload kvm_stat.service" in the
postrotate command.

> As much as I sympathize with re-use of existing components, I'd like to point
> out that my original patch was also re-using existing python code for rotating
> logs, and made things just _so_ much easier from a user perspective.

I understand that, yes.  My request was more about not requiring
kvm_stat-specific configuration than about reusing existing components,
though.

Paolo

