Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CADC1AC788
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 16:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408193AbgDPO4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 10:56:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32447 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728299AbgDPN4J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 09:56:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587045367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JuFxERZQeYWvTMOH9959cFOBhZFAe+8LyuDDmtHZT6g=;
        b=M1og8ZS1q6RWo8sHUEoy+wCPXuodeiU4XVzI8n0B/tt07jd61F/IIJQoAGrou8SGHNMTEl
        gODYTdmKafpoMBxe5ek9AqVMAO4zJNOL5ly5dJpEXwtOICs+2rmp+/2r+Zt6vcS55pXqNz
        dcBj2OzRosEWXA7VgRqLgN/lklBX9xc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-FkSmKLLKNuGATgRILKUSow-1; Thu, 16 Apr 2020 09:56:02 -0400
X-MC-Unique: FkSmKLLKNuGATgRILKUSow-1
Received: by mail-wr1-f71.google.com with SMTP id e5so1723743wrs.23
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 06:56:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JuFxERZQeYWvTMOH9959cFOBhZFAe+8LyuDDmtHZT6g=;
        b=G6U7tOQGaa8hbxrOQu8vMTZkBCkG4qcxj4HHQcTg6Lw41LnVORZephZnHTgGbaZZPe
         qXjNFuKZueZTuTamCoBvXm1N/U2VXiAKJCa6YTrVK1QOTOVKd3Wc0pGNLO/WTvThEQci
         ST4uKrb+A47XDUWZy+Z5fLa/2WOynFVlpsnniU0Ui/akdqaUG4a1TYX6lzEpIY93iLST
         NoHG0xFB1uBcx7VCcXXBpOq9NkLWW0X5q3QF/+QbTniBzJO2yLCCvW/unzf/eq6JK4hN
         Y5Sw8Y+iKnwZX9zujEBsCFBcYm5cwpsGe6zYt0GXdMCDqY37qajuLRD+QC8t3iQOGgvc
         ceOA==
X-Gm-Message-State: AGi0PubnzILGA4a1VppY3sd1BdwfE+d///4CMdmpwzjgyVndi6kU31RB
        7/khKKYKMdqCjHBeBdfQGoAy18xvqAsqOiNJURqCDvgWNRfBUFxfFvzV3g/1LNN9EdtSBUhxlMk
        v/gqdUTCx6ZV8
X-Received: by 2002:a05:600c:4096:: with SMTP id k22mr4630798wmh.99.1587045361173;
        Thu, 16 Apr 2020 06:56:01 -0700 (PDT)
X-Google-Smtp-Source: APiQypKmMby+sE4uXkksLI5PJVNgvsxDBAdWQuQg0r/VQXjbxQjfNa2fkxIa/IVsY3y0ANLelxu14A==
X-Received: by 2002:a05:600c:4096:: with SMTP id k22mr4630781wmh.99.1587045360916;
        Thu, 16 Apr 2020 06:56:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:399d:3ef7:647c:b12d? ([2001:b07:6468:f312:399d:3ef7:647c:b12d])
        by smtp.gmail.com with ESMTPSA id k23sm3958005wmi.46.2020.04.16.06.56.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 06:56:00 -0700 (PDT)
Subject: Re: [PATCH v2 0/3] tools/kvm_stat: add logfile support
To:     Stefan Raspl <raspl@linux.ibm.com>, kvm@vger.kernel.org
References: <20200402085705.61155-1-raspl@linux.ibm.com>
 <c6cd27e3-3af2-faa1-a375-f97490a9e078@linux.ibm.com>
 <f979cf19-d223-4cad-c2b9-f17739091dff@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cd0768fb-fa35-7076-d80f-45dd567f5152@redhat.com>
Date:   Thu, 16 Apr 2020 15:55:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <f979cf19-d223-4cad-c2b9-f17739091dff@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/04/20 09:18, Stefan Raspl wrote:
> On 2020-04-08 16:32, Stefan Raspl wrote:
>> On 2020-04-02 10:57, Stefan Raspl wrote:
>>> Next attempt to come up with support for logfiles that can be combined
>>> with a solution for rotating logs.
>>> Adding another patch to skip records with all zeros to preserve space.
>>>
>>> Changes in v2:
>>> - Addressed feedback from patch review
>>> - Beefed up man page descriptions of --csv and --log-to-file (fixing
>>>   a glitch in the former)
>>> - Use a metavar for -L in the --help output
>>>
>>>
>>> Stefan Raspl (3):
>>>   tools/kvm_stat: add command line switch '-z' to skip zero records
>>>   tools/kvm_stat: Add command line switch '-L' to log to file
>>>   tools/kvm_stat: add sample systemd unit file
>>>
>>>  tools/kvm/kvm_stat/kvm_stat         | 84 ++++++++++++++++++++++++-----
>>>  tools/kvm/kvm_stat/kvm_stat.service | 16 ++++++
>>>  tools/kvm/kvm_stat/kvm_stat.txt     | 15 +++++-
>>>  3 files changed, 101 insertions(+), 14 deletions(-)
>>>  create mode 100644 tools/kvm/kvm_stat/kvm_stat.service
>>
>> *ping*
> 
> So...any consideration?

Queued, thanks.  (Patches sent during the merge window are delayed and
this tends to result in LIFO order...)

Paolo

