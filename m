Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2CC7109C8D
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 11:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbfKZKuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 05:50:39 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49679 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727867AbfKZKug (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 05:50:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574765435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=R0suUB0h2cJm9IG+wl8vuFejSumo0ekP4tj9lnnUJew=;
        b=cHadvh1uPUOOU+zeOH82wn0Tuos97FBanLAfYLyNe4a0yUUl8SGU8QjJVZWrxQZMIBEQNG
        oH9LabWICJ/k2DM9d79ZtwNV/udBMU+3Sb16gXVw9DkbQmXD36fy76Qed2QfQ+SP6qdQTl
        B/tJizKBcJb0tBwVkFod7tcQBc/I/lY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-z0pIswJGOdyJVa5QfLwLLg-1; Tue, 26 Nov 2019 05:50:32 -0500
Received: by mail-wm1-f70.google.com with SMTP id f21so963424wmh.5
        for <kvm@vger.kernel.org>; Tue, 26 Nov 2019 02:50:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R0suUB0h2cJm9IG+wl8vuFejSumo0ekP4tj9lnnUJew=;
        b=SH86tq8TP4lDiPcX8X3iyhY5SUiU/sdonBRze1VFWpVDu9w+w/j3oKnqxA4cdnqJiN
         aldwWkr3Qg3PNzwK5iL2ZvRi/HCzGsacaRohgqlboKYis1L+uluRn7gCVeRghpMYWJH0
         34kYHIMmqtP/JXyxh9urU80aDrjljugb1K3Uk3zJH0Ya2i2bLwNA46Z1gTZ3DkzltYEV
         QEGhYVYVxx/H0ED6/LhzkhwL8ydOFUUv189EzT9P9g3DaD/IokSpOGjpSosiIR4Q4298
         YWLfs1n7hkjUdHibfqxxudRU5IFYalztbYgMXiptXyPQN5IYH6bS/id5CGWX0TEyhhTr
         YHiQ==
X-Gm-Message-State: APjAAAVN183/0I52AcrLSDj1f4F++bclvIKKTQ8ZYJX+a9LctWgyaZ6c
        Fx0VpEUVfmcS25V1rykrsE+5dL4gCijVLKygTtopRWDIcPYRIlu36DWyyojbXjDUO51GUKkmd34
        hlsR2S7kKtpko
X-Received: by 2002:adf:d091:: with SMTP id y17mr38095422wrh.182.1574765431444;
        Tue, 26 Nov 2019 02:50:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqxYWtiHjTbs2+gq5fix9nXS12FIn2I1K/paROsrcbJEox1XXKa4zTvdRRqUsp5+Wm4plu4R0A==
X-Received: by 2002:adf:d091:: with SMTP id y17mr38095394wrh.182.1574765431153;
        Tue, 26 Nov 2019 02:50:31 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5454:a592:5a0a:75c? ([2001:b07:6468:f312:5454:a592:5a0a:75c])
        by smtp.gmail.com with ESMTPSA id w11sm15560411wra.83.2019.11.26.02.50.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2019 02:50:30 -0800 (PST)
Subject: Re: "statsfs" API design
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     KVM list <kvm@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <5d6cdcb1-d8ad-7ae6-7351-3544e2fa366d@redhat.com>
 <20191109154952.GA1365674@kroah.com>
 <cb52053e-eac0-cbb9-1633-646c7f71b8b3@redhat.com>
 <20191126100948.GB1416107@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <75dc4403-cc07-0f99-00ec-86f61092fff9@redhat.com>
Date:   Tue, 26 Nov 2019 11:50:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191126100948.GB1416107@kroah.com>
Content-Language: en-US
X-MC-Unique: z0pIswJGOdyJVa5QfLwLLg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/11/19 11:09, Greg Kroah-Hartman wrote:
> So I think there are two different things here:
> 	- a simple data structure for in-kernel users of statistics
> 	- a way to export statistics to userspace
> 
> Now if they both can be solved with the same "solution", wonderful!  But
> don't think that you have to do both of these at the same time.
> 
> Which one are you trying to solve here, I can't figure it out.  Is it
> the second one?

I already have the second in KVM using debugfs, but that's not good.  So
I want to do:

- a simple data structure for in-kernel *publishers* of statistics

- a sysfs-based interface to export it to userspace, which looks a lot
like KVM's debugfs-based statistics.

What we don't have to do at the same time, is a new interface to
userspace, one that is more efficient while keeping the self-describing
property that we agree is needed.  That is also planned, but would come
later.

Paolo

