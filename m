Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7AD2F9D2A
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 11:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389291AbhARKsa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 05:48:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29686 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390151AbhARKY2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 05:24:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610965382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=witCwu7ifvDoAqmLiB6lhdS2QLBxr3oFfDNsXqgfxMg=;
        b=UGZX6BEKiPX4WrBMeMcqce/TL3UJmZxISkq2iKRFJdcw55/x33yZv0/BRQRbpNxJKDprq9
        KiIIQuZEdKivioLxdKDHqOYeIxMN8YGQkj+AhaVBxY7nxqOdwrdUuHYV0N9b7UKWq815xm
        ubfxYfIQegtlsLiZmtBsHmJGMM7O7y4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-Uy-WnpdaO4S7I6TUorZ1Ng-1; Mon, 18 Jan 2021 05:22:58 -0500
X-MC-Unique: Uy-WnpdaO4S7I6TUorZ1Ng-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D278B800D62;
        Mon, 18 Jan 2021 10:22:55 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-189.ams2.redhat.com [10.36.112.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D38DF5D9CD;
        Mon, 18 Jan 2021 10:22:48 +0000 (UTC)
Subject: Re: [PATCH v2 9/9] gitlab-ci: Add alpine to pipeline
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     qemu-devel@nongnu.org, Fam Zheng <fam@euphon.net>,
        Laurent Vivier <lvivier@redhat.com>,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Alistair Francis <alistair@alistair23.me>,
        Greg Kurz <groug@kaod.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Max Reitz <mreitz@redhat.com>, qemu-ppc@nongnu.org,
        Kevin Wolf <kwolf@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
 <20210118063808.12471-10-jiaxun.yang@flygoat.com>
 <20210118101159.GC1789637@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <94f9255b-59eb-3e1f-0691-c24751d04700@redhat.com>
Date:   Mon, 18 Jan 2021 11:22:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210118101159.GC1789637@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/01/2021 11.11, Daniel P. Berrangé wrote:
> On Mon, Jan 18, 2021 at 02:38:08PM +0800, Jiaxun Yang wrote:
>> We only run build test and check-acceptance as their are too many
>> failures in checks due to minor string mismatch.
> 
> Can you give real examples of what's broken here, as that sounds
> rather suspicious, and I'm not convinced it should be ignored.

I haven't tried, but I guess it's the "check-block" iotests that are likely 
failing with a different libc, since they do string comparison on the 
textual output of the tests. If that's the case, it would maybe be still ok 
to run "check-qtest" and "check-union" on Alpine instead of the whole 
"check" test suite.

  Thomas

