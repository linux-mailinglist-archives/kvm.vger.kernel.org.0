Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3307233FC8
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 09:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731564AbgGaHNZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 03:13:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25658 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731503AbgGaHNZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 03:13:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596179603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=j27UOSS6WjjKzhAPoByvuWvvbTswlwYQl+TxZanTfkY=;
        b=PkVXnHNByKgBSpYg6wA+yYkNA4cl6tTcDChXZPfKtfZ5vQInWcfl0JmcJlGZQLwDB/vou/
        9wqhZDQgx3lFA55bp8N/CMVQTefpy23dDx/f0DOnUhilf6zmcH3So50nalrbuVgGVrcJWz
        K5N9n4/lGHMMDPQqlCvi45m/TW9A3tc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-Jz8Miv3mO2KAYlxAG_OS9Q-1; Fri, 31 Jul 2020 03:13:21 -0400
X-MC-Unique: Jz8Miv3mO2KAYlxAG_OS9Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C132C1009440
        for <kvm@vger.kernel.org>; Fri, 31 Jul 2020 07:13:20 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-153.ams2.redhat.com [10.36.112.153])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E746F726BA;
        Fri, 31 Jul 2020 07:13:19 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] scripts/runtime: Replace "|&" with "2>&1
 |"
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
References: <20200731060909.1163-1-thuth@redhat.com>
 <20200731063200.ylvid4qrtvyduagr@kamzik.brq.redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b3e57992-3f61-50fb-4cbb-3f3a494d7639@redhat.com>
Date:   Fri, 31 Jul 2020 09:13:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200731063200.ylvid4qrtvyduagr@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/2020 08.32, Andrew Jones wrote:
> On Fri, Jul 31, 2020 at 08:09:09AM +0200, Thomas Huth wrote:
>> The "|&" only works with newer versions of the bash. For compatibility
>> with older versions, we should use "2>&1 |" instead.
> 
> Hi Thomas,
> 
> Which bash version are you targeting with this change?

I played a little bit with the macOS containers on Travis, to see
whether we could easily get some CI coverage for that after commit
7edd698ed003e introduced hvf support... and the bash version that Apple
ships is incredibly old (version 3). But it seems to break in some other
spots, too, so I think it likely makes more sense to install a newer
version of the bash with homebrew there...

> I think it's time we pick a bash version that we want to support
> (thoroughly test all the scripts with it) and then document it.

Makes sense. Version 3 is definitely too old ;-)

> As
> part of the CI we should test with both that version and with the
> latest released version
I think we should already have a good test coverage for newer versions
by using the latest version of Fedora in the CI.

For old versions, we could add a CI job based on CentOS 7 maybe? That
would be Bash v4.2 if I got that right...

 Thomas

