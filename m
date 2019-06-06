Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 170013770C
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 16:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbfFFOoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 10:44:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36186 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727309AbfFFOoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 10:44:25 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D48AF30832C8;
        Thu,  6 Jun 2019 14:44:24 +0000 (UTC)
Received: from localhost (dhcp-192-191.str.redhat.com [10.33.192.191])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 59C277D66E;
        Thu,  6 Jun 2019 14:44:20 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, libvir-list@redhat.com,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH RFC 0/1] mdevctl: further config for vfio-ap
Date:   Thu,  6 Jun 2019 16:44:16 +0200
Message-Id: <20190606144417.1824-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 06 Jun 2019 14:44:24 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds a very rough implementation of additional config data
for mdev devices. The idea is to make it possible to specify some
type-specific key=value pairs in the config file for an mdev device.
If a device is started automatically, the device is stopped and restarted
after applying the config.

The code has still some problems, like not doing a lot of error handling
and being ugly in general; but most importantly, I can't really test it,
as I don't have the needed hardware. Feedback welcome; would be good to
know if the direction is sensible in general.

Also available at

https://github.com/cohuck/mdevctl conf-data

Cornelia Huck (1):
  allow to specify additional config data

 mdevctl.libexec | 25 ++++++++++++++++++++++
 mdevctl.sbin    | 56 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 80 insertions(+), 1 deletion(-)

-- 
2.20.1

