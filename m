Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3BF114BF4D
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 19:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgA1SMF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 13:12:05 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51086 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726557AbgA1SMF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Jan 2020 13:12:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580235123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GFLzf10TgdyLAS21kd5LMRW5WkwaF17ngeycggVXre0=;
        b=MbGl3nDruxGUc0/XxLYM4MoWfStz+lk9i80Mlqf7IK05plAlxXI7d9mlA5JtAPyIavhFAW
        E92sw+GQJ+U1wHI26SpyltiKgIVTJBQhnOi30rLIKYQ92iA6XqMz9UVek3Gq0qeB8UCduM
        YE4NpZxwt+Mm8It35QnpUM5LR2TdPLM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-e92z4M5qO3GlcI3dHkgyxg-1; Tue, 28 Jan 2020 13:12:01 -0500
X-MC-Unique: e92z4M5qO3GlcI3dHkgyxg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 790C518C43C4;
        Tue, 28 Jan 2020 18:12:00 +0000 (UTC)
Received: from gondolin (ovpn-116-186.ams2.redhat.com [10.36.116.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D9B1A5DA7E;
        Tue, 28 Jan 2020 18:11:58 +0000 (UTC)
Date:   Tue, 28 Jan 2020 19:11:56 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 11/27] docs: kvm: convert devices/s390_flic.txt to ReST
Message-ID: <20200128191156.6bfb0b9b.cohuck@redhat.com>
In-Reply-To: <12634be89f4a8b662bf4bc0a0c7baef42675548f.1580219586.git.mchehab+huawei@kernel.org>
References: <cover.1580219586.git.mchehab+huawei@kernel.org>
        <12634be89f4a8b662bf4bc0a0c7baef42675548f.1580219586.git.mchehab+huawei@kernel.org>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Jan 2020 14:58:07 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> - Use standard markup for document title;
> - Adjust indentation and add blank lines as needed;
> - use the notes markup;
> - mark code blocks as such.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/virt/kvm/devices/index.rst      |  1 +
>  .../devices/{s390_flic.txt => s390_flic.rst}  | 68 +++++++++++--------
>  2 files changed, 39 insertions(+), 30 deletions(-)
>  rename Documentation/virt/kvm/devices/{s390_flic.txt => s390_flic.rst} (88%)

Looks sane to me.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

