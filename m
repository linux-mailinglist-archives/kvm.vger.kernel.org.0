Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F93B397884
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 18:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbhFAQ5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 12:57:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50571 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230288AbhFAQ5P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 12:57:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622566534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V46U5BjZCJkONhTvdGGIniGrnFBz3Ay4NH7d08zkjm8=;
        b=FRoxEMumDvsV34kn7mDgN4fsKM1GlWCu2f/GDU/ysIDoLV70MHfQYIF2bInchb+VNhYrfZ
        EXBrmhUSASDAtUdUFsLSfiGfK/vpfPXS0cEh3DR/hdn57Oqf7FKlXHL7k95kvl5H6l6VO0
        StR3MOdhO3DSHXJmWeuDO05gVUvnaoY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-F0wLloOoM82Tt1Ae2T9PUQ-1; Tue, 01 Jun 2021 12:55:30 -0400
X-MC-Unique: F0wLloOoM82Tt1Ae2T9PUQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6CB41020C33;
        Tue,  1 Jun 2021 16:55:29 +0000 (UTC)
Received: from localhost (ovpn-113-153.ams2.redhat.com [10.36.113.153])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 625DE60C0F;
        Tue,  1 Jun 2021 16:55:26 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] s390x: unify header guards
In-Reply-To: <20210601182545.36acdc98@ibm-vm>
Organization: Red Hat GmbH
References: <20210601161525.462315-1-cohuck@redhat.com>
 <20210601182545.36acdc98@ibm-vm>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Tue, 01 Jun 2021 18:55:24 +0200
Message-ID: <87k0ndr0cj.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Claudio Imbrenda <imbrenda@linux.ibm.com> writes:

> On Tue,  1 Jun 2021 18:15:25 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
>
>> Let's unify the header guards to _ASM_S390X_FILE_H_ respectively
>> _S390X_FILE_H_. This makes it more obvious what the file is
>> about, and avoids possible name space collisions.
>> 
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>
> LGTM, but... what about the other architectures? I think we should 
> try to standardize more generally

See my comment below :)

I think it would make sense to standardize all architectures; but I
would also like some feedback on the format I have chosen.

>
>> ---
>> 
>> Only did s390x for now; the other archs seem to be inconsistent in
>> places as well, and I can also try to tackle them if it makes sense.
>> 

