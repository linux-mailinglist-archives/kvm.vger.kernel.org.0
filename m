Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3497F6904
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2019 14:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfKJNFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Nov 2019 08:05:05 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:26216 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726436AbfKJNFE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 10 Nov 2019 08:05:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573391102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=7gRMPNYw34lDTRlozIuYBYq7yiTcWm+PL/XyWxXvOJs=;
        b=hEEWJtv0TroiCx1HmWMoBH7rNoiiQK9dNys3AvuZAa38GhbuLs0tU0iLqMQFh57rRX3L6o
        eai6MrrOPyn9qzffEH7v8ZACBQ0vTNATXkKDk6uhtFYSP55GHQMCkQOzFTtIMKyPElluDd
        MQFWGdIswvjj+D+Ai+9JUC5Rwi2Ti6k=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-RiD5mtZrNay__tZ6v0o4sg-1; Sun, 10 Nov 2019 08:04:59 -0500
Received: by mail-wr1-f71.google.com with SMTP id q6so4170420wrv.11
        for <kvm@vger.kernel.org>; Sun, 10 Nov 2019 05:04:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r4ocHX2cdbHorzLNLUlxaR7Gw/CEtZ3XrAz5MfTS5M0=;
        b=ADyWIrnhEvz1/XObwrVLorQf+RwulxkewxlIqVscxDLGyT60K+n6PlM31K3ANOOyDH
         QeNfThO//HMT8lrtBixCgRjOft918oc6nVSqOyQPu2bliZ5JvB6hFjRw51lwvAcXZKDe
         CTUo/YPPHbLXl6apRJSmIkgItgWMk2sDSyppZQqKoemKFjiLcMPIw4QSpvLWk4ACDyjD
         gCfyQ0YWGhvGfGmjHy9i+l89PT3RqdfOJiNDoU1/dUAMqTcXZx2WKWh7Fh4R4Pakmh26
         v7tj7fALLkB8TMQ1hCwcF6Xi+FKkm9Fo+S6Kqq+m86m7MU8QRdsJQrkuAe1Au+JPjrz2
         3uJg==
X-Gm-Message-State: APjAAAUxbg5/YFGZxRqEXCogf3mxqE6tMd42CtfjDQtObWGKfsLR0LpM
        zpBz4emutiZGEcCf5vIx2tQBO4rMOvgzRDBlVRfkKGO/9x+Lf+UAQ5KXdJMYlH36WQ/+dtlp29s
        kUeniMPswEGBd
X-Received: by 2002:adf:f60a:: with SMTP id t10mr13419534wrp.29.1573391098537;
        Sun, 10 Nov 2019 05:04:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqyyLQ4yghi59MGCVC5mlKrLaSgYtYO2JgP6e8kQ3KTCun93l6HkVXzx5aF8EkzrSLa6aN7qDw==
X-Received: by 2002:adf:f60a:: with SMTP id t10mr13419524wrp.29.1573391098200;
        Sun, 10 Nov 2019 05:04:58 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e8cd:9f0f:a5dc:7ad5? ([2001:b07:6468:f312:e8cd:9f0f:a5dc:7ad5])
        by smtp.gmail.com with ESMTPSA id o18sm16692717wrm.11.2019.11.10.05.04.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Nov 2019 05:04:57 -0800 (PST)
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <cb52053e-eac0-cbb9-1633-646c7f71b8b3@redhat.com>
Date:   Sun, 10 Nov 2019 14:04:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191109154952.GA1365674@kroah.com>
Content-Language: en-US
X-MC-Unique: RiD5mtZrNay__tZ6v0o4sg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/11/19 16:49, Greg Kroah-Hartman wrote:
> On Wed, Nov 06, 2019 at 04:56:25PM +0100, Paolo Bonzini wrote:
>> Hi all,
>>
>> statsfs is a proposal for a new Linux kernel synthetic filesystem, to be
>> mounted in /sys/kernel/stats, which exposes subsystem-level statistics
>> in sysfs.  Reading need not be particularly lightweight, but writing
>> must be fast.  Therefore, statistics are gathered at a fine-grain level
>> in order to avoid locking or atomic operations, and then aggregated by
>> statsfs until the desired granularity.
>=20
> Wait, reading a statistic from userspace can be slow, but writing to it
> from userspace has to be fast?  Or do you mean the speed is all for
> reading/writing the value within the kernel?

Reading/writing from the kernel.  Reads from a userspace are a superset
of reading from the kernel, writes from userspace are irrelevant.

[...]

>> As you can see, values are basically integers stored somewhere in a
>> struct.   The statsfs_value struct also includes information on which
>> operations (for example sum, min, max, average, count nonzero) it makes
>> sense to expose when the values are aggregated.
>=20
> What can userspace do with that info?

The basic usage is logging.  A turbostat-like tool that is able to use
both debugfs and tracepoints is already in tools/kvm/kvm_stat.

> I have some old notes somewhere about what people really want when it
> comes to a good "statistics" datatype, that I was thinking of building
> off of, but that seems independant of what you are doing here, right?
> This is just exporting existing values to userspace in a semi-sane way?

For KVM yes.  But while I'm at it, I'd like the subsystem to be useful
for others so if you can dig out those notes I can integrate that.

> Anyway, I like the idea, but what about how this is exposed to
> userspace?  The criticism of sysfs for statistics is that it is too slow
> to open/read/close lots of files and tough to get "at this moment in
> time these are all the different values" snapshots easily.  How will
> this be addressed here?

Individual files in sysfs *should* be the first format to export
statsfs, since quick scripts are an important usecase.  However, another
advantage of having a higher-level API is that other ways to access the
stats can be added transparently.

The main requirement for that is self-descriptiveness, blindly passing
structs to userspace is certainly the worst format of all.  But I don't
like the idea of JSON or anything ASCII; that adds overhead to both
production and parsing, for no particular reason.   Tracepoints already
do something like that to export arguments, so perhaps there is room to
reuse code or at least some ideas.  It could be binary sysfs files
(again like tracing) or netlink, I haven't thought about it at all.

Paolo

