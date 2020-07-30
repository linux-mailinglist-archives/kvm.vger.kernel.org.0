Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76469232B7B
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 07:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbgG3Fl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 01:41:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24501 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728631AbgG3Fly (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 01:41:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596087713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:openpgp:openpgp;
        bh=LSbNPSX1IivrWAhCixs/WiLSxawS4h1PQ2eaDpFv3oI=;
        b=c6JJAtoHQvKNr5HYzhwNZursgL23Brt+57LIA+vuAVj6/W/y7yn4ehRYJXn70iFcl4hXYU
        M4RvW1BW0ValQ7B0YOlqIJaHQnhacOddyoNHH46eRtsDlZxrQo+dZzU7tYERn92kcXEvqP
        SRvEMDYb9Xc++6/xuhB/F51MZyStFJ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-7htQllwcNIOKoaWxTawD-w-1; Thu, 30 Jul 2020 01:41:51 -0400
X-MC-Unique: 7htQllwcNIOKoaWxTawD-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DB2580183C;
        Thu, 30 Jul 2020 05:41:49 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-85.ams2.redhat.com [10.36.112.85])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A47D5619B5;
        Thu, 30 Jul 2020 05:41:43 +0000 (UTC)
To:     KVM <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nadav Amit <namit@vmware.com>,
        Liran Alon <liran.alon@oracle.com>,
        sean.j.christopherson@intel.com
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Subject: A new name for kvm-unit-tests ?
Message-ID: <dc518389-945a-1887-7ad0-00ebaf9ae30e@redhat.com>
Date:   Thu, 30 Jul 2020 07:41:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


 Hi all,

since Paolo recently suggested to decrease the bus factor for
kvm-unit-tests [1], I suggested (in a private mail) to maybe also move
the repo to one of the git forges where we could benefit from a CI
system (so that we do not merge bugs so often anymore as it happened in
the previous months). If we do that step, that might be a good point in
time to rename the kvm-unit-tests to something more adequate. "Why?" you
might ask ... well, the unit tests are not only useful for kvm anymore:

- They can also be used for testing TCG in QEMU

- There have been attempts in the past to use them for OpenBSD [2]

- They can be used for hvf on macOS now [3]

- The s390x tests can also be run with the z/VM and LPAR hypervisors

- Some people also try to run certain tests on x86 bare metal
  (for comparing the behavior of virtual CPUs with real CPUs)

Liran already suggested the name "cpu-unit-tests" a while ago [4], which
is certainly a better description of what the tests are doing nowadays.
But I wonder whether that name is maybe too generic? For example, if
someone does not know that there should be dashes in between and just
searches for "cpu unit tests" with their favorite search engine, would
they find the right project site?

Maybe we should come up with a more fancy name for the test suite? For
example something like "HECATE" - "*H*ypervisor *E*xecution and *C*pu
instruction *A*dvanced *T*est *E*nvironment" (and Hecate is also the
goddess of boundaries - which you could translate to the hypervisor
being the boundary between the virtual and real machine ... with a
little bit of imagination, of course) ... well, yeah, that's just what
came to my mind so far, of course. Let's brainstorm ... do you have any
good ideas for a new name of the kvm-unit-tests? Or do you love the old
name and think it should stay? Or do you think cpu-unit-tests would be
the best fit? Please let us know!

 Thanks,
  Thomas



[1]
https://lore.kernel.org/kvm/e79b76ae-c554-6d28-7556-88b280b8f02f@redhat.com

[2] https://patchwork.kernel.org/patch/9625205/#20244627

[3]
https://lore.kernel.org/kvm/20200320145541.38578-3-r.bolshakov@yadro.com/

[4] https://patchwork.kernel.org/patch/11260891/#23021859

