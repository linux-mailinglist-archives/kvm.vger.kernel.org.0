Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B081BA053
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 11:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgD0JtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 05:49:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20567 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726349AbgD0JtM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 05:49:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587980951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qLuzVeIGtHjNnvhWI7G809z76fTCxCvUxioh1QTBMgc=;
        b=LViiRz1yBE9uRKcqA3qY3sMzdjSg+yt1IqFP0ECEm9rIDy8aoKd+EXsWnz1cZ8c57EMpLa
        2q/JI2LzS0Kh2Z2a7kCkcXWyiHSID7OowASRX6jQICbkqklZJme+o2+L20UQ1yTv2LdcY7
        31C9T49Exko4EEm54l/VjSO8Tkv9UQQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-aKJmmSh2MheZxG__kZIhig-1; Mon, 27 Apr 2020 05:49:09 -0400
X-MC-Unique: aKJmmSh2MheZxG__kZIhig-1
Received: by mail-wm1-f70.google.com with SMTP id o26so8460815wmh.1
        for <kvm@vger.kernel.org>; Mon, 27 Apr 2020 02:49:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qLuzVeIGtHjNnvhWI7G809z76fTCxCvUxioh1QTBMgc=;
        b=M1pW/kIjxqLwOV9tbnN0BIIzW7P0qfs/5fgPBtzj5fUfYcOQ473B1fnhVu0sDgr6DN
         otsvH1zTqwN3b/Kws5c7q4UFBKepQivn17GbadQM5HkKq74VHEXgpokcqyiKriTPs6U4
         Gge3Uk6ZFSQB5vzI7Z9c4SL+6BM6FHFLlzsn3vpdFMTW0MRalBEQyXnoAPilRvQDdfWf
         qzUgrPLiH5M3u9ns4HGk0odVDxEgC4MvLZAf7cBzJGeOyvNbNB8v+QVylEzkrHmcXMz/
         EEZ+jNSgyo0mMdz90h4zDLyKbCHmC80NfoE4hzpB8EYJMLmkZpLcEAjfdv6TIlGwxD9S
         9rKA==
X-Gm-Message-State: AGi0PuZq5YBHck4vx+4Th5oNB5KlzGFjiHCzL7i7zJWIpfejG6HAmWp/
        GS5sPuXN6gEQ705oYhIpdiRTSb7jjJe9CPfQPGk9p62cenyYESsHHDGphuf/l4oSXzYx1Gng2Co
        9K1X3GG6U6hux
X-Received: by 2002:a7b:c84f:: with SMTP id c15mr23872499wml.166.1587980947749;
        Mon, 27 Apr 2020 02:49:07 -0700 (PDT)
X-Google-Smtp-Source: APiQypKSCCSEo/IUap21LF/LKNKSXQ68wlspkJLGATRQxBBAxTNotluNK9KtvIErIgkKA34OdFkAfg==
X-Received: by 2002:a7b:c84f:: with SMTP id c15mr23872476wml.166.1587980947509;
        Mon, 27 Apr 2020 02:49:07 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id s14sm15057222wme.33.2020.04.27.02.49.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 02:49:07 -0700 (PDT)
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>,
        Alexander Graf <graf@amazon.com>, linux-kernel@vger.kernel.org
Cc:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>, Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
References: <20200421184150.68011-1-andraprs@amazon.com>
 <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
 <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
 <2a4a15c5-7adb-c574-d558-7540b95e2139@redhat.com>
 <1ee5958d-e13e-5175-faf7-a1074bd9846d@amazon.com>
 <f560aed3-a241-acbd-6d3b-d0c831234235@redhat.com>
 <80489572-72a1-dbe7-5306-60799711dae0@amazon.com>
 <0467ce02-92f3-8456-2727-c4905c98c307@redhat.com>
 <5f8de7da-9d5c-0115-04b5-9f08be0b34b0@amazon.com>
 <095e3e9d-c9e5-61d0-cdfc-2bb099f02932@redhat.com>
 <602565db-d9a6-149a-0e1a-fe9c14a90ce7@amazon.com>
 <fb0bfd95-4732-f3c6-4a59-7227cf50356c@redhat.com>
 <fe8940ff-9deb-1b2b-8f30-2ecfe26ce27b@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <617eb49c-0ad9-8cf4-54bc-6d2cdfbb189a@redhat.com>
Date:   Mon, 27 Apr 2020 11:46:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <fe8940ff-9deb-1b2b-8f30-2ecfe26ce27b@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/04/20 11:22, Paraschiv, Andra-Irina wrote:
>>
>>
>> 1) having the kernel and initrd loaded by the parent VM in enclave
>> memory has the advantage that you save memory outside the enclave memory
>> for something that is only needed inside the enclave
> 
> Here you wanted to say disadvantage? :)Wrt saving memory, it's about
> additional memory from the parent / primary VM needed for handling the
> enclave image sections (such as the kernel, ramdisk) and setting the EIF
> at a certain offset in enclave memory?

No, it's an advantage.  If the parent VM can load everything in enclave
memory, it can read() into it directly.  It doesn't to waste its own
memory for a kernel and initrd, whose only reason to exist is to be
copied into enclave memory.

Paolo

