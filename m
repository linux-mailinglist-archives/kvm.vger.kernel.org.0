Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3AE04AA8E
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 21:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730452AbfFRTDH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 15:03:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51174 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730445AbfFRTDH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 15:03:07 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 11047C18B2DE;
        Tue, 18 Jun 2019 19:03:07 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-30.ams2.redhat.com [10.36.116.30])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 173EB98B5;
        Tue, 18 Jun 2019 19:03:04 +0000 (UTC)
Date:   Tue, 18 Jun 2019 21:03:03 +0200
From:   Kevin Wolf <kwolf@redhat.com>
To:     Juan Quintela <quintela@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] KVM call minutes for 2019-06-18
Message-ID: <20190618190303.GF4296@localhost.localdomain>
References: <87d0jb9cex.fsf@trasno.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d0jb9cex.fsf@trasno.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 18 Jun 2019 19:03:07 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 18.06.2019 um 16:49 hat Juan Quintela geschrieben:
> * Kevin is experimenthing with an external qemu-storage daemon
> * qemu-storage daemon vs process for each image
>   * compromise: less isolation but easier to do
> * i.e. just doing the full subsystem instead of each device

This is something that users can do then, but it's not a must.

The storage daemon is just a building block, and it's completely up to
the user whether they start a single daemon with many --blockdev options
and exports, or whether they start many daemons that serve only a single
image each.

Kevin
