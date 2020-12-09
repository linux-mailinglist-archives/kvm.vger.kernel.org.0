Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7F02D4096
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 12:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730396AbgLILCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 06:02:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26204 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730195AbgLILCi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 06:02:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607511672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nYf8gkeZQWjwQidxiaCVPuAJw4N+H7IMiSq03rKVBoQ=;
        b=QYdLFgHPoamQPho25fVXsLebkNU2kxMbxAS2ArOtspVHWs1nbojefSzLsSIc9q9ZluJ4yf
        fAAhz/SL8fwRSRjA1ai+ZtbJy/P19DF1J7PJgcR81qJDPXQucfuhFeIRxlp2oXzFKEWrFL
        47iCiVaMDLge0t0ldM2/V8zfkMBDWdE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-mgdINaRSPKOB1yQSfw56GQ-1; Wed, 09 Dec 2020 06:01:10 -0500
X-MC-Unique: mgdINaRSPKOB1yQSfw56GQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1D488049C3;
        Wed,  9 Dec 2020 11:01:09 +0000 (UTC)
Received: from gondolin (ovpn-113-135.ams2.redhat.com [10.36.113.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5A676EF54;
        Wed,  9 Dec 2020 11:01:04 +0000 (UTC)
Date:   Wed, 9 Dec 2020 12:01:02 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 1/2] s390x: Move to GPL 2 and SPDX
 license identifiers
Message-ID: <20201209120102.3d997c86.cohuck@redhat.com>
In-Reply-To: <20201208150902.32383-2-frankja@linux.ibm.com>
References: <20201208150902.32383-1-frankja@linux.ibm.com>
        <20201208150902.32383-2-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  8 Dec 2020 10:09:01 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> In the past we had some issues when developers wanted to use code
> snippets or constants from the kernel in a test or in the library. To
> remedy that the s390x maintainers decided to move all files to GPL
> 2 (if possible).
> 
> At the same time let's move to SPDX identifiers as they are much nicer
> to read.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/cmm.c       | 4 +---
>  s390x/cpumodel.c  | 4 +---
>  s390x/css.c       | 4 +---
>  s390x/cstart64.S  | 4 +---
>  s390x/diag10.c    | 4 +---
>  s390x/diag288.c   | 4 +---
>  s390x/diag308.c   | 5 +----
>  s390x/emulator.c  | 4 +---
>  s390x/gs.c        | 4 +---
>  s390x/iep.c       | 4 +---
>  s390x/intercept.c | 4 +---
>  s390x/pfmf.c      | 4 +---
>  s390x/sclp.c      | 4 +---
>  s390x/selftest.c  | 4 +---
>  s390x/skey.c      | 4 +---
>  s390x/skrf.c      | 4 +---
>  s390x/smp.c       | 4 +---
>  s390x/sthyi.c     | 4 +---
>  s390x/sthyi.h     | 4 +---
>  s390x/stsi.c      | 4 +---
>  s390x/uv-guest.c  | 4 +---
>  s390x/vector.c    | 4 +---
>  22 files changed, 22 insertions(+), 67 deletions(-)

Yeah for SPDX!

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

