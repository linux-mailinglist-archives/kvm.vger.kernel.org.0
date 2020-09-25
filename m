Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF252780D5
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 08:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgIYGoi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 02:44:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40875 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726990AbgIYGoi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 02:44:38 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601016276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CB9nNBQb56BWB0R6AidJPIUPTUzqy4DMBRgV+44h6h0=;
        b=DZ/cNJwEJal58FjwU0Voe0kuiff5LzrYmsW+3vMZXiLTaJdNPfBnMZC1kroehr8sPQy48p
        81utx5TZlltdSqW1AeYugZ/p1rVseM5O7DoCLlp8KLyJ14Lzd+el0fqZNG3KCtIBhGnWUc
        nzDKo9vv/dM+8ZW0mIydPZjxmXp3CZU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-AhU35fN1NqS7kLnyVenfmQ-1; Fri, 25 Sep 2020 02:44:34 -0400
X-MC-Unique: AhU35fN1NqS7kLnyVenfmQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47194100746C;
        Fri, 25 Sep 2020 06:44:33 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-251.ams2.redhat.com [10.36.112.251])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F3D65C1C7;
        Fri, 25 Sep 2020 06:44:28 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 2/9] travis.yml: Rework the x86 64-bit
 tests
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Drew Jones <drjones@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20200924161612.144549-1-thuth@redhat.com>
 <20200924161612.144549-3-thuth@redhat.com>
Message-ID: <7fddef3b-7a01-b084-d33a-b4e4f8291aed@redhat.com>
Date:   Fri, 25 Sep 2020 08:44:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200924161612.144549-3-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/2020 18.16, Thomas Huth wrote:
> We currently have three test jobs here:
> 
> 1) gcc, in-tree build
> 2) gcc, out-of-tree build
> 3) clang, in-tree build
> 
> Keeping everything in perspective, it should be sufficient to only use two
> build jobs for this, one in-tree with one compiler, and one out-of-tree
> with the other compiler.
> So let's re-order the jobs accordingly now. And while we're at it, make
> sure that all additional tests that work with the newer QEMU from Ubuntu
> Focal now are tested, too, and that we check all possible tests with
> Clang (i.e. the same list as with GCC except for the "realmode" test
> that still causes some problems with Clang).

This patch needs a rebase now since the realmode test has just been
fixed and added to .travis.yml ... I'll wait one or two more days for
review feedback, then respin a v2 with the conflict solved.

 Thomas

