Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647471CF32F
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 13:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729243AbgELLQx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 07:16:53 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37699 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728085AbgELLQx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 May 2020 07:16:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589282212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MLWC9tiJgqJ4f9t7I2NkuKApfx65ObWmgWxE+kr2YFg=;
        b=LDvsAdyD9dKqPd3LW2kywMxcHmd6dRWGNYSvfyaHNCI7y6YyIRZFaElXGUG3epWzO7zykO
        gxWPSeoXfadidPJhBfIstYKPN/4XTxVqmqPi6WFaXPP7WvNCTU3x9XZ/V91r7hR9KbWiTP
        WHpFQbtZZG20vbO4WllTsRrFm6fhubQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-C4f_ajaDNqa9YGj5dZxytQ-1; Tue, 12 May 2020 07:16:50 -0400
X-MC-Unique: C4f_ajaDNqa9YGj5dZxytQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CA8C800687;
        Tue, 12 May 2020 11:16:49 +0000 (UTC)
Received: from linux.fritz.box (ovpn-114-74.ams2.redhat.com [10.36.114.74])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 260211036B4B;
        Tue, 12 May 2020 11:16:42 +0000 (UTC)
Date:   Tue, 12 May 2020 13:16:41 +0200
From:   Kevin Wolf <kwolf@redhat.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Fam Zheng <fam@euphon.net>,
        kvm@vger.kernel.org, qemu-block@nongnu.org,
        qemu-trivial@nongnu.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH v4 0/6] scripts: More Python fixes
Message-ID: <20200512111641.GJ5951@linux.fritz.box>
References: <20200512103238.7078-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200512103238.7078-1-philmd@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 12.05.2020 um 12:32 hat Philippe Mathieu-Daudé geschrieben:
> Trivial Python3 fixes, again...
> 
> Since v3:
> - Fixed missing scripts/qemugdb/timers.py (kwolf)
> - Cover more scripts
> - Check for __main__ in few scripts

I'm not sure if the __main__ check actually provides anything useful in
source files of standalone tools that aren't supposed to be imported
from somewhere else. But of course, it's not wrong either.

Reviewed-by: Kevin Wolf <kwolf@redhat.com>

