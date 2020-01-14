Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC6DB13AD63
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 16:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgANPTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 10:19:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52505 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726335AbgANPTI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jan 2020 10:19:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579015147;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=7Av0EBC0wUnvR4uT/GA5tywrrcCx0R1RquP+AjiCYvQ=;
        b=I5n7FLhIwjhmTkIZ9xoSPLClzlg3Sf85z7KpjHLwY+bq9Hsa/v+e+faPhXGuUeF2NTbjuC
        q4uwXlIOR7xkIDkDWIgIBB7rVRD3oa3EIxUVtMWjhOkZ87LDbTV6+nsp8+BXDIhmqFnxwN
        opyoKAK1JbJEyME9rTde+jD4Vc33EDY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-w55Pz8RfMd6pfpM9iq-rKQ-1; Tue, 14 Jan 2020 10:19:06 -0500
X-MC-Unique: w55Pz8RfMd6pfpM9iq-rKQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 080D3DB20;
        Tue, 14 Jan 2020 15:19:05 +0000 (UTC)
Received: from redhat.com (unknown [10.36.118.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D62C60BE0;
        Tue, 14 Jan 2020 15:19:04 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: KVM call minutes for 2020-01-14
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 14 Jan 2020 16:19:02 +0100
Message-ID: <87imlecbh5.fsf@secure.laptop>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi

This notes are very terse because the discussion was quite technical and
I am not familiar with this part of qemu.  Feel free to fill this.


- libmuser:
    * Take all the complication of implementing the device
    * support several transport types?
    * mediated devices
    * tcp or rdma connection
    * VMI vs VMF
    * SPDK
    * Oracle move from unix socket to muser
    * Will we use it over kernel or over userspace?
    * For polling we are single process
    * How do handle recovery, outside process can have quite a bit of state
- multi-process
   * trying to integrate multiuser + muser
   * look if their vision is ok with qemu expectations
   * one continue with muser kernel module
   * other is vfio over unix socket
   * preferrence is going vfio over unix socket
     this allows all implementations work
- out of tree device
   * problematic
   * require to link with qemu
   * what about dpdk and other external
   * other appoarch: vfio with outside device
- vfio over sockets
   * who is doing that work?
   * felipe prototype it long ago
- best way to get this multiprocess in
  * they have worked on this for a long time
  * no idea about how to go from there

Later, Juan.

