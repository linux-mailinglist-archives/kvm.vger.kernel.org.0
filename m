Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECD5DFB084
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 13:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfKMMfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 07:35:15 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60445 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726105AbfKMMfM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 07:35:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573648511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wLUkuRgQ4SVbO301yVcYFCGO1j6Ke50Ly3zfYVd64wk=;
        b=CJb8SDgCAlk6G230PucVRXDmvwYCsKf7To1DuZ22/+vxOOVBmXaFIENQ0xCPaBF2hjYrXl
        gXbOUme6Mkr7IvZuYMKBbWfy/MU1GFDweC6IQ2ZW68lyEUkejB+IGzXUOtIec0uodykU+K
        A1bBBgg5e4w3wPuF0DggqhV5Fy8UCqY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-E6bKDt-lOA2w8YxXbWQcbg-1; Wed, 13 Nov 2019 07:35:10 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01A6118B5F6A;
        Wed, 13 Nov 2019 12:35:09 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-183.ams2.redhat.com [10.36.116.183])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B5DAD60467;
        Wed, 13 Nov 2019 12:35:02 +0000 (UTC)
Subject: Re: [PATCH v1 0/4] s390x: Testing the Subchannel I/O
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com
References: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <30d17ea4-1c35-f44a-8736-05725b251c69@redhat.com>
Date:   Wed, 13 Nov 2019 13:35:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: E6bKDt-lOA2w8YxXbWQcbg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 Hi Pierre!

Meta-comment: Please use "[kvm-unit-tests PATCH ...]" in the subject for
future kvm-unit-tests patches.

On 13/11/2019 13.23, Pierre Morel wrote:
[...]
> The simple test tests the I/O reading by the SUB Channel. It needs QEMU t=
o
> be patched to have the pong device defined.

Are you going to send QEMU patches for this? I assume that's a
prerequisite for this patch series?

 Thomas

