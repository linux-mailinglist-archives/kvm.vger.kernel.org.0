Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D50BE4FBF6
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2019 15:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfFWNyc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 23 Jun 2019 09:54:32 -0400
Received: from connect.ultra-secure.de ([88.198.71.201]:50994 "EHLO
        connect.ultra-secure.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbfFWNyc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Jun 2019 09:54:32 -0400
X-Greylist: delayed 474 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Jun 2019 09:54:31 EDT
Received: (Haraka outbound); Sun, 23 Jun 2019 15:44:43 +0200
Authentication-Results: connect.ultra-secure.de; iprev=pass; auth=pass (plain); spf=none smtp.mailfrom=ultra-secure.de
Received-SPF: None (connect.ultra-secure.de: domain of ultra-secure.de does not designate 217.71.83.52 as permitted sender) receiver=connect.ultra-secure.de; identity=mailfrom; client-ip=217.71.83.52; helo=[192.168.1.201]; envelope-from=<rainer@ultra-secure.de>
Received: from [192.168.1.201] (217-071-083-052.ip-tech.ch [217.71.83.52])
        by connect.ultra-secure.de (Haraka/2.6.2-toaster) with ESMTPSA id 1F81627D-62F9-460A-BD9D-8150D6B27873.1
        envelope-from <rainer@ultra-secure.de> (authenticated bits=0)
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 verify=NO);
        Sun, 23 Jun 2019 15:44:38 +0200
From:   Rainer Duffner <rainer@ultra-secure.de>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Question about KVM IO performance with FreeBSD as a guest OS
Message-Id: <3924BBFC-42B2-4A28-9BAF-018AA1561CAF@ultra-secure.de>
Date:   Sun, 23 Jun 2019 15:46:29 +0200
To:     kvm@vger.kernel.org
X-Mailer: Apple Mail (2.3445.104.11)
X-Haraka-GeoIP: EU, CH, 451km
X-Haraka-ASN: 24951
X-Haraka-GeoIP-Received: 
X-Haraka-ASN: 24951 217.71.80.0/20
X-Haraka-ASN-CYMRU: asn=24951 net=217.71.80.0/20 country=CH assignor=ripencc date=2003-08-07
X-Haraka-FCrDNS: 217-071-083-052.ip-tech.ch
X-Haraka-p0f: os="Mac OS X " link_type="DSL" distance=14 total_conn=1 shared_ip=N
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on spamassassin
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.1
X-Haraka-Karma: score: 6, good: 9778, bad: 13, connections: 10632, history: 9765, asn_score: 1301, asn_connections: 1470, asn_good: 1308, asn_bad: 7, pass:asn, relaying
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I have huge problems running FreeBSD 12 (amd64) as a KVM guest.

KVM is running on Ubuntu 18 LTS, in an OpenStack setup with dedicated Ceph-Storage (NVMe SSDs).

The VM „flavor" as such is that IOPs are limited to 2000/s - and I do get those 2k IOPs when I run e.g. CentOS 7.

But on FreeBSD, I get way less.

E.g. running dc3dd to write zeros to a disk, I get 120 MB/s on CentOS 7.
With FreeBSD, I get 9 MB/s.


The VMs were created on an OpenSuSE 42.3 host with the commands described here:

https://docs.openstack.org/image-guide/freebsd-image.html


This mimics the results we got on XenServer, where also some people reported the same problems but other people had no problems at all.

Feedback from the FreeBSD community suggests that the problem is not unheard of, but also not universally reproducible.
So, I assume it must be some hypervisor misconfiguration?

I’m NOT the administrator of the KVM hosts. I can ask them tomorrow, though.

I’d like to get some ideas on what to look for on the hosts directly, if that makes sense.




Thanks in advance,
Rainer
