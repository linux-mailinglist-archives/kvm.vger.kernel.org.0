Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD804161209
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 13:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbgBQMbJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 07:31:09 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27937 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728615AbgBQMbJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 07:31:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581942668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eIVN+UnU8zoh6z+m89NaIgo85XHlSENueiAawUkZG54=;
        b=VsZFpuybTqEguMo2vZPjCjmFYqK41CIA7LgcW7su1xCxT2WvIb20icl7A4+fQOPLQbZ4E5
        /WxuMi7vrmQR06yfiLVBGNmAVUhm5mhLDc/2TBDYO6vEFq8ZZ++IdfM/8Anl2cj5X2vA20
        LV92jg4xCvxA6deP2B/7s1JnZkpcC9E=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-q1HSG1KiMz2F98CnVvr-VA-1; Mon, 17 Feb 2020 07:31:00 -0500
X-MC-Unique: q1HSG1KiMz2F98CnVvr-VA-1
Received: by mail-wm1-f71.google.com with SMTP id b133so6947501wmb.2
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 04:31:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=eIVN+UnU8zoh6z+m89NaIgo85XHlSENueiAawUkZG54=;
        b=WxeXmjesPeZjAcHQkAyqAW8yqBg1bUDIcWKJw+neZxXpygGfGDTcOJSi8KDGVzUXxT
         fXge4SxtzdvqtGsH1foOLlkLBIWXDZYn4HtbG39kMuU5y+l4w8odBJ0hdY6HPaOZbzCJ
         3hJQMQDFpj4lWp+mww/kfEEKvFq7KQYxNJ9WXD5GxkXGpPqPSH8WDFDPBEdJ3uIt40aq
         OJM7RxY8if/RH57uN9w6ove4ZT3p/EHSqdJu0/IoPLmgRCHLBxgauMNddAuFJr8iJ6rc
         2lZjwZrgQa3h8MyAxi6LW+ts+C0Ntq3k4evkAoqW1DU3aAWte9a7RJS9vHgj6W3JV72J
         7tlA==
X-Gm-Message-State: APjAAAVU9svtaIAuGCI4ZvAQiYRoclQeuqXyQw9a/Uc+1vXG830ay87L
        IZw5fOemMWxjV3FCcM6fDdJ0IAmBLLOPDUDownwWtPwkO1gLru7oWujy6lWc3sEZYH2LKj5OzXm
        VyeNsiG3i5Q1A
X-Received: by 2002:a1c:7907:: with SMTP id l7mr21544739wme.37.1581942659605;
        Mon, 17 Feb 2020 04:30:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqwtFs9TRXBR00iHpsdraUIhJYa2/F0S2D29ZQHvh5jaXCPBbUA0FA8qbDhMpxnFqZyQI463uw==
X-Received: by 2002:a1c:7907:: with SMTP id l7mr21544725wme.37.1581942659353;
        Mon, 17 Feb 2020 04:30:59 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id d204sm415752wmd.30.2020.02.17.04.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 04:30:58 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Christophe de Dinechin <dinechin@redhat.com>
Cc:     kvm <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: CPU vulnerabilities in public clouds
In-Reply-To: <3EF2160E-1D1F-4389-8C5E-AC6A84630711@redhat.com>
References: <CAJSP0QW0XqgVfBbS9ip8xL+TkMfu24A+GyKVQLurCwWc2fTEvQ@mail.gmail.com> <3EF2160E-1D1F-4389-8C5E-AC6A84630711@redhat.com>
Date:   Mon, 17 Feb 2020 13:30:58 +0100
Message-ID: <874kvpbdkt.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Christophe de Dinechin <dinechin@redhat.com> writes:

>> On 5 Feb 2020, at 17:06, Stefan Hajnoczi <stefanha@gmail.com> wrote:
>> 
>> Hi Vitaly,
>> I just watched your FOSDEM talk on CPU vulnerabilities in public clouds:
>> https://mirror.cyberbits.eu/fosdem/2020/H.1309/vai_pubic_clouds_and_vulnerable_cpus.webm
>> 
>> If I understand correctly the situation for cloud users is:
>> 1. The cloud provider takes care of hypervisor and CPU microcode fixes
>> but the instance may still be vulnerable to inter-process or guest
>> kernel attacks.
>> 2. /sys/devices/system/cpu/vulnerabilities lists vulnerabilities that
>> the guest kernel knows about.  This might be outdated if new
>> vulnerabilities have been discovered since the kernel was installed.
>> False negatives are possible where your slides show the guest kernel
>> thinks there is no mitigation but you suspect the cloud provider has a
>> fix in place.
>> 3. Cloud users still need to learn about every vulnerability to
>> understand whether inter-process or guest kernel attacks are possible.
>> 
>> Overall this seems to leave cloud users in a bad situation.  They
>> still need to become experts in each vulnerability and don't have
>> reliable information on their protection status.
>> 
>> Users with deep pockets will pay someone to do the work for them. For
>> many users the answer will probably be to apply guest OS updates and
>> hope for the best? :(
>> 
>> It would be nice if /sys/devices/system/cpu/vulnerabilities was at
>> least accurate...  Do you have any thoughts on improving the situation
>> for users?
>
> I understand your concern, and it’s a great point.
>
> However, /sys is about the local system, so I’m not overly shocked
> that it does not know about what is outside the system :-)
>
> What could be nice, though, is if /sys/…/vulnerabilities exposed
> a list of CVEs that have been taken into account at the time
> the kernel was built.
>
> # cat /sys/devices/system/cpu/vulnerabilities/CVE_list 
> 2017-5715
> 2017-5753
> 2017-5754
> 2018-3615
> 2018-3620
> 2018-3646
> 2018-12207
> 2018-12130
> 2018-12126
> 2018-12127
> 2019-11091
> 2018-3639
> 2019-11135
>
> That way, you would know at least what you are measuring against.
> The implementation is quite easy, see experiment here:
>
> https://github.com/c3d/linux/commits/cpu-bugs-cve-list
>
> Do you think that would have any value?
>

In a way, yes. The list basically tells you 'your kernel *knows* about
these CVEs as it was released after their release dates' but there is
still some uncertainty for the user: OK, a CVE exists but is my CPU
actually vulnerable? It may happen that when CVE releases we think that
some CPUs (or a particular arch) are not vulnerable but we change our
mind later. Also, all vulnerabilities are different as the severity
depends a lot on the workload. The actions one need to undertake differ
(update microcode, disable SMT, pin tasks to certain cores/threads,
...). The bottom line is I don't see an easy path for users. They either
trust the source of their bits (e.g. distro), the infrastructure
(hardware/virtual/cloud) and the default settings as being 'secure
enough' or they have to study the details...

-- 
Vitaly

