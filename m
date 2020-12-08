Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB7D2D2E25
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 16:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730082AbgLHPX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 10:23:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24558 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729386AbgLHPX1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Dec 2020 10:23:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607440921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SVKce79MwbLjO0x0J4zqXVr6BjKuBMavk1Bfxy6sQmY=;
        b=WpOcYEJdj0FEwxNiqG2YA6rZt4kwA6a8rvgqOE+19hflaHC4BcdWNulWTC56ELAz2ToS1E
        HuI7JxirpaQr/KI71UA7iQ+iAa6uvMhfB5LwTI5+6nb+zCSKiUOtNIrAwnPZQjNhribWNJ
        or+r/WR50+ji69MdUXsHuU6fLkF8WGs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-80--bTywaRZN0qqt1inHU5Jcw-1; Tue, 08 Dec 2020 10:21:56 -0500
X-MC-Unique: -bTywaRZN0qqt1inHU5Jcw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9D191015ED8;
        Tue,  8 Dec 2020 15:21:42 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-38.ams2.redhat.com [10.36.112.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3B4360877;
        Tue,  8 Dec 2020 15:21:40 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 2/2] s390x: lib: Move to GPL 2 and SPDX
 license identifiers
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20201208150902.32383-1-frankja@linux.ibm.com>
 <20201208150902.32383-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <4f5ae2c0-65ff-1c12-958d-d6478fe1383b@redhat.com>
Date:   Tue, 8 Dec 2020 16:21:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201208150902.32383-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/12/2020 16.09, Janosch Frank wrote:
> In the past we had some issues when developers wanted to use code
> snippets or constants from the kernel in a test or in the library. To
> remedy that the s390x maintainers decided to move all files to GPL 2
> (if possible).
> 
> At the same time let's move to SPDX identifiers as they are much nicer
> to read.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Thomas Huth <thuth@redhat.com>

