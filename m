Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4193123405E
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 09:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731696AbgGaHpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 03:45:44 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20813 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731678AbgGaHpn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jul 2020 03:45:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596181542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8lhRC0CmqkXl0SilgG/GMWzrZn9mSwXCDhK4r7aEcoA=;
        b=D224RgjYO9OD2elU0JnqrUtpTI2+lALG3FrWz6a5fCaYROplKnrhgFLT0mmqjtWXUGjAM4
        TyNk/uKe9rT0UZ7FE19zu7Y7QtAhp9IbZTxtjWX1jwD8gsCRimFHcVRmhRyH5gprUVgw1D
        lkHUb/Nkb1s80aSyFNDvgXk40WwN2/M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-lxjeD9VZMpqEldaMMGg8gA-1; Fri, 31 Jul 2020 03:45:40 -0400
X-MC-Unique: lxjeD9VZMpqEldaMMGg8gA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1FA718839CF
        for <kvm@vger.kernel.org>; Fri, 31 Jul 2020 07:45:39 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.116])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CA4EB6932B;
        Fri, 31 Jul 2020 07:45:38 +0000 (UTC)
Date:   Fri, 31 Jul 2020 09:45:35 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] scripts/runtime: Replace "|&" with "2>&1
 |"
Message-ID: <20200731074535.vntfhmciwf3q3awj@kamzik.brq.redhat.com>
References: <20200731060909.1163-1-thuth@redhat.com>
 <20200731063200.ylvid4qrtvyduagr@kamzik.brq.redhat.com>
 <b3e57992-3f61-50fb-4cbb-3f3a494d7639@redhat.com>
 <805d57bb-be3d-50af-a40f-4d37629d42d5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <805d57bb-be3d-50af-a40f-4d37629d42d5@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 31, 2020 at 09:17:53AM +0200, Paolo Bonzini wrote:
> On 31/07/20 09:13, Thomas Huth wrote:
> > the bash version that Apple ships is incredibly old (version 3).
> 
> Yes, due to GPLv3.  :(  I think either we rewrite the whole thing in
> Python (except for the "shar"-like code in mkstandalone.sh)

I once suggested Python (or anything less awkward than Bash) be used
for our harness, but ARM people told me that they like Bash because
then they can install the unit tests on minimal images that they
use on the ARM models. There may other "embedded" cases for kvm-unit-tests
in the future too, if we were to introduce bare-metal targets, etc.,
so I think the minimal language (Bash) requirement makes sense to
maintain (not to mention we already wrote it...)

> or we keep
> bash 4 as the minimum supported version.

Is 4.2 OK? That would allow Thomas' CI to get the coverage we need
by using CentOS, without having to install a specific Bash.

Thanks,
drew

