Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1308E255422
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 07:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgH1F4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 01:56:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37501 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725858AbgH1F4E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Aug 2020 01:56:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598594162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8WfSS1tY+bLb7KnTMyymrfaeRnFVFOa+gLmOLZfJg4c=;
        b=NCs9DwIrfhVpYJP49RrD77Bbcqjk/3XNbkHxUPA42X8ox22p+G/QVWtA26W4CKiScX4Svf
        1nnMUTfQQuY17XtZH+JaBI567GPUXxkcHB3KB7ct9dku5Izhqae8fPMaQpvlNMdkzwzupY
        1D0mDiLQ6NwK2/tciNrcmOoTCqysPt0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-h09BYIRsPsW9BYFg6-zX2Q-1; Fri, 28 Aug 2020 01:55:57 -0400
X-MC-Unique: h09BYIRsPsW9BYFg6-zX2Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA4A2189E615;
        Fri, 28 Aug 2020 05:55:55 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-79.ams2.redhat.com [10.36.112.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0DAA5D9F1;
        Fri, 28 Aug 2020 05:55:54 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 6/7] configure: Add an option to specify
 getopt
To:     Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org
Cc:     Cameron Esfahani <dirty@apple.com>
References: <20200810130618.16066-1-r.bolshakov@yadro.com>
 <20200810130618.16066-7-r.bolshakov@yadro.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <ebccbbb2-dc9b-9ff4-c89c-8fdd6f463a50@redhat.com>
Date:   Fri, 28 Aug 2020 07:55:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200810130618.16066-7-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/08/2020 15.06, Roman Bolshakov wrote:
> macOS is shipped with an old non-enhanced version of getopt and it
> doesn't support options used by run_tests.sh. Proper version of getopt
> is available from homebrew but it has to be added to PATH before invoking
> run_tests.sh. It's not convenient because it has to be done in each
> shell instance and there could be many if a multiplexor is used.
> 
> The change provides a way to override getopt and halts ./configure if
> enhanced getopt can't be found.
> 
> Cc: Cameron Esfahani <dirty@apple.com>
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  configure    | 13 +++++++++++++
>  run_tests.sh |  2 +-
>  2 files changed, 14 insertions(+), 1 deletion(-)

Is this still required with a newer version of bash? The one that ships
with macOS is just too old...

I assume that getopt is a builtin function in newer versions of the bash?

Last time we discussed, we agreed that Bash v4.2 would be a reasonable
minimum for the kvm-unit-tests:

 https://www.spinics.net/lists/kvm/msg222139.html

Thus if the user installed bash from homebrew on macos, we should be fine?

Could you maybe replace this patch with a check for a minimum version of
bash instead?

 Thomas

