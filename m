Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC03B21A0F5
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 15:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgGINd3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 09:33:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25854 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726410AbgGINd3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 09:33:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594301608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p43UIFy8qtmd83okViGUI3Ft//gtWVQ0TxEHPBKHNmQ=;
        b=I1bAs2EuVFMBneO3ZwUpR+MTtWYRlqBSojRiqJpUBbdyT9pJdr9AgOhdo0aV9+GkmPD1hl
        mClluX+H/VJ9sS33cx1IsDbKpmKyFAUwT2CVnoVEa94XMyx3ubKNUuuKDLAAcnkapGYnQZ
        YbIBQF1yYbUPyBKv+Y/+56Tpgflo4Ug=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-h4mfr5ZfMcSBzZfGyFZi4w-1; Thu, 09 Jul 2020 09:33:27 -0400
X-MC-Unique: h4mfr5ZfMcSBzZfGyFZi4w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FB46100AA22;
        Thu,  9 Jul 2020 13:33:26 +0000 (UTC)
Received: from gondolin (ovpn-113-62.ams2.redhat.com [10.36.113.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8BEA10016DA;
        Thu,  9 Jul 2020 13:33:21 +0000 (UTC)
Date:   Thu, 9 Jul 2020 15:33:18 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        drjones@redhat.com
Subject: Re: [kvm-unit-tests PATCH v11 9/9] s390x: css: ssch/tsch with sense
 and interrupt
Message-ID: <20200709153318.2931430d.cohuck@redhat.com>
In-Reply-To: <9aba6196-edd4-4eb0-1e1c-e6410291863b@linux.ibm.com>
References: <1594282068-11054-1-git-send-email-pmorel@linux.ibm.com>
        <1594282068-11054-10-git-send-email-pmorel@linux.ibm.com>
        <20200709141348.6ae5ff18.cohuck@redhat.com>
        <9aba6196-edd4-4eb0-1e1c-e6410291863b@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Jul 2020 15:18:25 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2020-07-09 14:13, Cornelia Huck wrote:
> > On Thu,  9 Jul 2020 10:07:48 +0200
> > Pierre Morel <pmorel@linux.ibm.com> wrote:

> >> +	if (irb.scsw.sch_stat & !(SCSW_SCHS_PCI | SCSW_SCHS_IL)) {  
> > 
> > Did you mean ~(SCSW_SCHS_PCI | SCSW_SCHS_IL)?  
> 
> grrr... yes, thanks.
> 
> > 
> > If yes, why do think a PCI may show up?  
> 
> Should not in the current implementation.
> I thought I can add it as a general test.

Yeah, maybe in the future. But for now, I think it is a bit confusing.

