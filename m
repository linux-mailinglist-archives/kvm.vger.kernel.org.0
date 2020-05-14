Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09BA1D2F29
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 14:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgENMIp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 08:08:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22634 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726160AbgENMIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 08:08:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589458120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kmsV2G4Qwm1I0U8bJOAPNfjndsg10A088/8OhVQeJQ0=;
        b=J456KuQAAVlsDqnQJCWBjha53E9PjyL1hQ5bgoI/IJzjMRF1A8734fd4eCw+lhoyyYU6iB
        +4gyJkI0jN1oYcF6Wjco9PmZreAPWMVQHFKKed6LPyN3VsRWRSbCweCFahIYUAJAnoWVpZ
        RSvqD1pTJQVLMn9qCmC3lLlMIXl7KX8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-1hmfRn1TOLmymacye7qTIw-1; Thu, 14 May 2020 08:08:39 -0400
X-MC-Unique: 1hmfRn1TOLmymacye7qTIw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2C5C108BD15;
        Thu, 14 May 2020 12:08:37 +0000 (UTC)
Received: from gondolin (unknown [10.40.192.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E3536EA00;
        Thu, 14 May 2020 12:08:11 +0000 (UTC)
Date:   Thu, 14 May 2020 14:08:08 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v6 07/10] s390x: css: msch, enable test
Message-ID: <20200514140808.269f6485.cohuck@redhat.com>
In-Reply-To: <abafd691-d9ab-33b2-c522-d37fecc3e881@linux.ibm.com>
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
        <1587725152-25569-8-git-send-email-pmorel@linux.ibm.com>
        <cff917e0-f7e0-fd48-eda5-0cbe8173ae8a@linux.ibm.com>
        <abafd691-d9ab-33b2-c522-d37fecc3e881@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Apr 2020 10:27:36 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2020-04-27 15:11, Janosch Frank wrote:
> > On 4/24/20 12:45 PM, Pierre Morel wrote:  

> >> This is NOT a routine to really enable the channel, no retry is done,
> >> in case of error, a report is made.  
> > 
> > Would we expect needing retries for the pong device?  
> 
> Yes it can be that we need to retry some instructions if we want them to 
> succeed.
> This is the case for example if we develop a driver for an operating system.
> When working with firmware, sometime, things do not work at the first 
> time. Mostly due to races in silicium, firmware or hypervisor or between 
> them all.
> 
> Since our purpose is to detect such problems we do not retry 
> instructions but report the error.
> 
> If we detect such problem we may in the future enhance the tests.

I think I've seen retries needed on z/VM in the past; do you know if
that still happens?

