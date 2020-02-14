Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 977AF15D612
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 11:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbgBNKvl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 05:51:41 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38544 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726220AbgBNKvl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 05:51:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581677499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7oS6qPRTWAcSh1xwsTps0ddgDaOPTPDtHt5BvNvlXNk=;
        b=i7/1m+MYwuezSoReDsFvrxSyyjS5nNOkgGokZaCdl9CD70jnaHGJlN+/hjVr++9VNipJ5o
        LeRyIhFwimN0Px9lMHaazSQcTAXZ6QA3p7j6wjmXTz4M4R4bC96jDdG1g/SzUKEWxhfpQE
        7f+vOOdVsLkWEnprg2fTmaYP+GxIz6U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-htjPEdjFNkiufYKQkG20Ew-1; Fri, 14 Feb 2020 05:51:30 -0500
X-MC-Unique: htjPEdjFNkiufYKQkG20Ew-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0228800D48;
        Fri, 14 Feb 2020 10:51:29 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FAA562670;
        Fri, 14 Feb 2020 10:51:22 +0000 (UTC)
Date:   Fri, 14 Feb 2020 11:51:20 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, peter.maydell@linaro.org,
        alex.bennee@linaro.org, lvivier@redhat.com, thuth@redhat.com,
        david@redhat.com, frankja@linux.ibm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests 1/2] arch-run: Allow $QEMU to include
 parameters
Message-ID: <20200214105120.qjgrwewm74sh32db@kamzik.brq.redhat.com>
References: <20200213143300.32141-1-drjones@redhat.com>
 <20200213143300.32141-2-drjones@redhat.com>
 <c14fd5b0-9658-dbe9-a2b2-bf368d57fc7d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c14fd5b0-9658-dbe9-a2b2-bf368d57fc7d@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 11:31:04AM +0100, Paolo Bonzini wrote:
> On 13/02/20 15:32, Andrew Jones wrote:
> > +	if [ -n "$QEMU" ]; then
> > +		set -- $QEMU
> > +		if ! "$1" --help 2>/dev/null | grep -q 'QEMU'; then
> > +			echo "\$QEMU environment variable not set to a QEMU binary." >&2
> > +			return 2
> > +		fi
> > +		qemu=$(command -v "$1")
> > +		shift
> > +		echo "$qemu $@"
> 
> I think $* is more appropriate here.  Something like "foo $@ bar" has a
> weird effect:

Will fix for v2.

> 
> 	$ set -x
> 	$ set a b c
> 
> 	$ echo "foo $@ bar"
> 	+ echo 'foo a' b 'c bar'
> 	foo a b c bar
> 
> 	$ echo "foo $* bar"
> 	+ echo 'foo a b c bar'
> 	foo a b c bar
> 
> Otherwise, this is a good idea.

Thanks,
drew

> 
> Thanks,
> 
> Paolo
> 
> > +		return
> > +	fi
> > +
> 

