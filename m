Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C803D545BA3
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 07:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbiFJFYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 01:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234071AbiFJFYM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 01:24:12 -0400
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 09 Jun 2022 22:24:10 PDT
Received: from smtp687out9.mel.oss-core.net (smtp687out9.mel.oss-core.net [210.50.216.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F1C5726444F
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 22:24:10 -0700 (PDT)
X-IPAS-Result: =?us-ascii?q?A2DQUABh1KJi/2o43G9aGgEBAQEBDS8BAQEBAgIBAQEBA?=
 =?us-ascii?q?gEBAQEDAQEBAQELCQmBSIE6AgGkQ4cZG4IliWMLAQEBITAEAQGEeAEBWQWEc?=
 =?us-ascii?q?yY4EwECBAEBAQEDAgMBAQEBAQEDAQEGAQEBAQEBBgSBHIUvRoZUIAcBgVYBD?=
 =?us-ascii?q?gEehXYBATGsHYEzDXSEWRSCEAQKgnOBOwIBAQGJSoVgfYEQgViCOAGFfYNAg?=
 =?us-ascii?q?i4EkjqFQQQbOgMfFRM0EoEhRSwBCAYGBwoFMgYCDBgUBAITElMdAhIMChwOV?=
 =?us-ascii?q?BkMDwMSAxEBBwILEggVLAgDAgMIAwIDLgIDFwkHCgMdCAoKEhIQFAIEBg0eC?=
 =?us-ascii?q?wgDGR8sCQIEDgNFCAsKAxEEAxMYCxYIEAQGAwkvDSgLAxQPAQYDBgIFBQEDI?=
 =?us-ascii?q?AMUAwUnBwMhBwsmDQ0EIx0DAwUmAwICGwcCAgMCBhcGAgJvCiYNCAQIBAwQH?=
 =?us-ascii?q?SQQBQIHMQUELwIeBAUGEQkCFgIGBAUCBAQWAgISCAIIJxsHFjYZAQUOTwYLC?=
 =?us-ascii?q?SEcCSARBQYWAyNxBUgPKTU2PBAfIRwKLAZ8D50gkkiQQ542CoNOBSkHgQoHn?=
 =?us-ascii?q?kwxg2MBlxMRASeBV4tUlmqoEoEZgX5wFYIIgRxQKJ0QgRACBgsBAQMJjlwBA?=
 =?us-ascii?q?Q?=
IronPort-Data: A9a23:yRBMx6vBxd20fS0jKUzz2CoI6efnVNdcMUV32f8akzHdYApBsoF/q
 tZmKWCPPf2DZ2Pyf91xbo2y9kIFscKEzYAwHAA5/iBkECNHgMeUXt7xwmXYYXrOcpWroGGLT
 ik6QoOdRCzhZiaE/n9BClVlxJVF/fngqoDUUYYoAQgsA149IMsdoUg7wbRh3Ncw2YHR7z6l4
 LseneWOYDdJ5BYsWo4kw/rrRMRH5amaVJsw5zTSVNgT1LPsvyB94KE3ecldG0DFrrx8RYZWc
 QpsIIaRpQs19z91Yj+sfy2SnkciGtY+NiDW4pZatjTLbhVq/kQPPqgH2PU0MFkJl2mQp4lL0
 NBcsa23Zxc0YfKcl7FIO/VYO3kW0axux57hZFrgnuK/5WThLiLOqxlsJBhvZMtCoL4xXD8Ir
 KRGQNwORknra+aewbS1TcFpj8IvPY/gO4Z3VnRInWuFVq18Ecqrr6Pi6Y8I8jxgislyDOvlS
 JMgKiBWbjiRbEgaUrsQINdk9AuyvVH8bThwtl2Yv+w07nLVwQg316LiWOc5YfTTHJwQxBzA4
 z+Yuj2hXFcBKNXZ1jCf9XugjObJkWX9VZ5UHaDQGuNWvWB/D1c7UHU+PWZXa9Hj4qJic7qz8
 3Apxxc=
IronPort-HdrOrdr: A9a23:lVrVaqpIgBBk8ahlI04QNIsaV5pIeYIsimQD101hICG9Ffb2qy
 nOppgmPHDP6Qr5NEtKpTn/Asm9qBrnnPZICO8qU4tKNzONhILHFuxf0bc=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.91,288,1647262800"; 
   d="scan'208";a="82433282"
Received: from 111-220-56-106.sta.wbroadband.net.au (HELO WIN-J7GFDBAO51J) ([111.220.56.106])
  by smtp687.mel.oss-core.net with ESMTP; 10 Jun 2022 15:23:05 +1000
From:   "Perry Davidson" <info@mandy.com>
Subject: Acknowledge this message
To:     <kvm@vger.kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Reply-To: <pd1086787@gmail.com>
Date:   Thu, 9 Jun 2022 22:23:05 -0700
Message-Id: <2022090622230414E662E257-B7D2A780FA@mandy.com>
X-Spam-Status: Yes, score=7.8 required=5.0 tests=BAYES_50,
        FREEMAIL_FORGED_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_LOW,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.7 RCVD_IN_DNSWL_LOW RBL: Sender listed at https://www.dnswl.org/,
        *       low trust
        *      [210.50.216.236 listed in list.dnswl.org]
        *  1.3 RCVD_IN_BL_SPAMCOP_NET RBL: Received via a relay in
        *      bl.spamcop.net
        *      [Blocked - see <https://www.spamcop.net/bl.shtml?111.220.56.106>]
        *  3.3 RCVD_IN_SBL_CSS RBL: Received via a relay in Spamhaus SBL-CSS
        *      [111.220.56.106 listed in zen.spamhaus.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 SPF_SOFTFAIL SPF: sender does not match SPF record (softfail)
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [pd1086787[at]gmail.com]
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I will send you more details as soon as you acknowledge this message.
Thank you.
Perry Davidson.

