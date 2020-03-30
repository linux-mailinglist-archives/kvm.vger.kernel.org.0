Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC234197BF2
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 14:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730188AbgC3Mf7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 08:35:59 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:40400 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730064AbgC3Mf7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 08:35:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585571757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SHqw2R/e3Qz/q0dhM5eA1psqOHqGJjAamd88CFmvi9I=;
        b=CSkJhtfJbbQMZcWpTZJzUmntvosybUsZZqr+st2aOgWg+3Lo5kvgBXdy9qo4qfm2MZijmk
        VgkgzuTh7oKemz+/ijQfMSHKKAomzMFChNt8djiBjEbrc0v6f03EjOJ0CtXu1mqRpvaIkJ
        6Vob6lT0rI4W0rD8S7ebvTdWhHXBAPY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-LvSVraFqOJq5vArOT7eJug-1; Mon, 30 Mar 2020 08:35:55 -0400
X-MC-Unique: LvSVraFqOJq5vArOT7eJug-1
Received: by mail-wr1-f72.google.com with SMTP id t25so8841866wrb.16
        for <kvm@vger.kernel.org>; Mon, 30 Mar 2020 05:35:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SHqw2R/e3Qz/q0dhM5eA1psqOHqGJjAamd88CFmvi9I=;
        b=gVtf1RNV4zoFqFNNI47cX8iJ1Gn08a0Hb9A80OF+magcG9RSkJENDLU7GWO+5PfYxQ
         Z/kjsn/Bx7168pSoEGhOytriRo7GUA6p+apnYgLvPdfQ5/u54ynXNm/NF/qMqcOVGQt1
         X42dSHCrxuWqECzJutmYV2DDBeXWhRhUo6zsA41fwuErH2MRIVyuByyXkr+n4DgkeSmW
         P5ijNPHmGggGsJGtb9IqAwQLwjs9w1I+DSGKFz7LzeLlVEMziMtGNb9dHHhOGCInxdkI
         bCLIrDmJMGu/ei/aSqlJ6g70FO895aBSiisoaQOL/XN4XZuU7yqwQLTeLX+vz1CvBDt9
         5O/A==
X-Gm-Message-State: ANhLgQ2w6PJulhwLP56qL2zK/o48aW2NV5ezAOEYyvdKZ3Z0xQ9plaZ0
        hn7wrOhpS6EpnyI1sYNJX7EtYpRTRKzdk1zFK1LumFcdggLzLr49nyjjUCNAMkNBJy/7uU0oliF
        G8LT3xFcM8KQ1
X-Received: by 2002:a05:600c:a:: with SMTP id g10mr13188226wmc.153.1585571751493;
        Mon, 30 Mar 2020 05:35:51 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsJkkkmKncqd/taAAaQNAO/rSlmXiNtrEayertzG3W7G65ozcuVK5VNnmH2piYOxnripuWRvw==
X-Received: by 2002:a05:600c:a:: with SMTP id g10mr13188205wmc.153.1585571751150;
        Mon, 30 Mar 2020 05:35:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b55d:5ed2:8a41:41ea? ([2001:b07:6468:f312:b55d:5ed2:8a41:41ea])
        by smtp.gmail.com with ESMTPSA id y11sm12648965wmi.13.2020.03.30.05.35.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2020 05:35:50 -0700 (PDT)
Subject: Re: [PATCH 0/7] tools/kvm_stat: add logfile support
To:     Stefan Raspl <raspl@linux.ibm.com>, kvm@vger.kernel.org
References: <20200306114250.57585-1-raspl@linux.ibm.com>
 <7f396df1-9589-6dd0-0adf-af4376aa8314@redhat.com>
 <d893c37d-705c-b9a1-cf98-db997edf3bce@linux.ibm.com>
 <5c350f55-64be-43fc-237d-7f71b4e9afdc@redhat.com>
 <7c8b614a-a7a1-d33e-8762-b06d4b2fd45b@linux.ibm.com>
 <d0143786-04e5-a9f8-bd87-d4c06cee1856@redhat.com>
 <cb983917-2c40-5002-b001-093f25e199a2@linux.ibm.com>
 <341997c9-7bda-c699-3a85-8f98e4500dbe@redhat.com>
 <43d8da60-9f1c-7e0b-4efd-14f2a600d58d@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e2958d40-875c-7ee0-3c12-302d3d8d0b98@redhat.com>
Date:   Mon, 30 Mar 2020 14:35:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <43d8da60-9f1c-7e0b-4efd-14f2a600d58d@linux.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/03/20 14:24, Stefan Raspl wrote:
> I was using copytruncate indeed. But removing it, things still don't work
> (kvm_stat continues to write to B). But maybe there's a deeper misunderstanding:
> My assumption is you'd do something like 'kvm_stat -l > /var/log/kvm_stat.txt'.
> If so, how could kvm_stat ever be aware of where its output gets redirected to,
> nevermind open/closing any of those files? Or did you mean kvm_stat should close
> & open stdout?!

You're right, we need to have a file name command line option for
kvm_stat, for logrotate to work.  (BTW the file would be opened with
O_APPEND, so the equivalent shell command line would use >> rather than >).

>> You could stat the output file, and suppress the header if it is a
>> regular non-empty file.  But it would be a problem anyway if the header
>> has changed since the last boot, which prompts the stupid and lazy
>> question: how does your series deal with this?
> 
> How could we stat the output file if kvm_stat is just writing to a console?

You can fstat it---either stdout or the file opened with the new command
line option.

>>> As much as I sympathize with re-use of existing components, I'd like to point
>>> out that my original patch was also re-using existing python code for rotating
>>> logs, and made things just _so_ much easier from a user perspective.
>>
>> I understand that, yes.  My request was more about not requiring
>> kvm_stat-specific configuration than about reusing existing components,
>> though.
>
> Taking a step back and looking at the tightly integrated kvm_stat - logrotate -
> systemd approach outlined above, I'd bet most users would prefer a
> self-contained solution in kvm_stat that merely requires adding a single extra
> command line switch. And they can still add systemd on top, which wouldn't need
> to interact with any of the other components except to start kvm_stat initally.

It seems to me that using systemd and logrotate makes it possible to
support progressive enhancement of kvm_stat's logging capabilities:

- curses-based logging
- manual CSV logging to disk (using > or >>)
- CSV logging to /var via systemd unit
- CSV logging to /var via systemd unit, with log rotation

Indeed using logrotate would not make it possible to do manual CSV
logging with log rotation, since the postrotate command uses systemctl.
 However it's only log rotation that would require using the systemd
unit, and systemd does not have to interact with logrotate, so the
integration seems relatively loose to me.

Paolo

