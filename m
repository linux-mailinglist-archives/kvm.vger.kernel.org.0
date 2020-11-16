Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7A32B4372
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 13:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729958AbgKPMRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 07:17:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37132 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727895AbgKPMRA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 07:17:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605529018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AUzFchKqJccPtpxefapWXQR6l1pXP6azylCK/gQYpEc=;
        b=CQQVp5FLUzwgVoMzaj6OcKziw1EZqoD4IMlGfflMuEZErfH7O0tfssemyeVzE1QzkP8oj8
        sgSzdI7t1lNd1gpozmTEylinNbxO05nZgXpe0l6O0PeMrjQXdZJ7zNj+DOfn0CC3JO7hnW
        wZ+1gWTPK3bhjqy6K3X9RbQoVwGPLqk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-42lIX4UgMOWUMwB7obHgBw-1; Mon, 16 Nov 2020 07:16:56 -0500
X-MC-Unique: 42lIX4UgMOWUMwB7obHgBw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C09C80205E;
        Mon, 16 Nov 2020 12:16:55 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.122])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 313DB55765;
        Mon, 16 Nov 2020 12:16:51 +0000 (UTC)
Date:   Mon, 16 Nov 2020 13:16:48 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: Re: [PATCH v2 06/11] KVM: selftests: dirty_log_test: Remove create_vm
Message-ID: <20201116121648.w7szgu36fb2tqdi4@kamzik.brq.redhat.com>
References: <20201111122636.73346-1-drjones@redhat.com>
 <20201111122636.73346-7-drjones@redhat.com>
 <5a580018-21ea-1222-b3aa-a6de284596ea@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a580018-21ea-1222-b3aa-a6de284596ea@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 13, 2020 at 05:42:01PM +0100, Paolo Bonzini wrote:
> > 
> 
> This one (even after fixing conflicts) breaks the dirty ring test.
>

Maybe the problem was patch 3/11 was missing? For me after rebasing
3/11 this patch applied cleaning and worked. The only change I made
was to address Peter's nit.

Thanks,
drew

