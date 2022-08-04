Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A821758963B
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 04:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236977AbiHDCmb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 3 Aug 2022 22:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237036AbiHDCm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 22:42:29 -0400
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 03 Aug 2022 19:42:27 PDT
Received: from lvs-smtpgate1.nz.fh-koeln.de (lvs-smtpgate1.nz.FH-Koeln.DE [139.6.1.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03E720F7D;
        Wed,  3 Aug 2022 19:42:27 -0700 (PDT)
Message-Id: <178efe$1vdl5b@smtp.intranet.fh-koeln.de>
X-IPAS-Result: =?us-ascii?q?A2D//wCJMOti/wQiBotaHQEBPAEFBQECAQkBFYFRARoIA?=
 =?us-ascii?q?YEWAgFPAQEBgRSBLAEBK4ROg0+IT4NDAYEpgnWLFYFjBQKPBAsBAQEBAQEBA?=
 =?us-ascii?q?QEJEgIlCQQBAYUDAVMBAQEBB4QdJjgTAQIEAQEBAQMCAwEBAQEBAQMBAQgBA?=
 =?us-ascii?q?QEBBgSBHIUvOQ1fAQEBgQw0AQEBhBABAQEGAQEBK2sgAhkNAkkWRwEBAQGCR?=
 =?us-ascii?q?kUBAQGCHQEBMxOiIYdhgTGBAYIpgSYBgQuCKQWCcoEXKgIBAQGHZ5BcgQ8BA?=
 =?us-ascii?q?oUYHROCUgSXcQICGjgDNBEeNwsDXQgJFxIgAgQRGgsGAxY/CQIEDgNACA0DE?=
 =?us-ascii?q?QQDDxgJEggQBAYDMQwlCwMUDAEGAwYFAwEDGwMUAwUkBwMcDyMNDQQfHQMDB?=
 =?us-ascii?q?SUDAgIbBwICAwIGFQYCAk45CAQIBCsjDwUCBy8FBC8CHgQFBhEIAhYCBgQEB?=
 =?us-ascii?q?AQWAhAIAggnFwcTMxkBBVkQCSEcCR8QBQYTAyBtBUUPKDM1PCsfGwpgJwsqJ?=
 =?us-ascii?q?wQVAwQEAwIGEwMDIgIQLjEDFQYpExItCSp1CQIDIm0DAwQoLgMJPgcJJixMP?=
 =?us-ascii?q?g+WRIINgTgCMIcLjUKDZQWKVKBbCoNRgUQCk32MKIJGknQOBJF9CYVvhHaME?=
 =?us-ascii?q?KdXgXiBfnCBbgolgRtRGQ+SEopfdAI5AgYBCgEBAwmMZIEKgRgBAQ?=
IronPort-Data: A9a23:T7jnUa95TFXihsXTjL2bDrUD2niTJUtcMsCJ2f8bNWPcYEJGY0x3z
 2AaUGrUb/iKNzCjfN9zbIvg9xgGvsWGz9MyQAY+qHpEQiMRo6IpJzg4wmQcnc+2BpeeJK6yx
 5xGMrEsFOhtEjmG4E/F3oHJ9RFUzbuPSqf3FNnKMyVwQR4MYCo6gHqPocZg6mJVqYHR7z2l6
 IuaT/L3ZQfNNw5cago896+FoRVzi/X+0BtwUosWPK0jUPf2zhH5PbpHTU2DByKQrrp8QoZWc
 93+IISRpQs1yfuN5uSNyd4XemVSKlLb0JPnZnB+A8BOiTAazsA+PzpS2Pc0MS9qZzu1c99Zy
 9R37qKWaAIQL6z2ouk3AjNHHBpxFPgTkFPHCSDXXc276mTtKibCmLNwFEdwM41d+eF6BWcI+
 fFwxDIlN0vSwbzwm+79FoGAhex6RCXvFIYWsXJtyyPYALM6XIzfR6ji7tYexi12jcdLdRrbT
 5RHNGIwPUifC/FJEn0pE8kczfyxv1rEeGFomU+Wv+ky7HeGmWSd15C3aYGMIYzbLSlPpW6Gq
 37D/mD+DB8bP9G3zD2D7n+yj+vLmmX2VJ96PKK4//puhVSV7mkUDgEbS1K/pf7/h0KjM/pRL
 FYO9zEyp4A380q3Q8f0Wxm/5nOIo3Y0XtNTFOMh6wCBwILR5ACFC3YNSjpGLtEqqaceQD0sy
 1mIxoq2WxRvt6GQQHOZsLyTqFuaIjUNNWgYeQcZRwIO4NX5p5l1hRXKJv5pDbW0iNDuAhnty
 TmBryQkgK1VhskOv42h8F/GhDS3rJnNSg8z6S3XU2uh8gNhbZS5YYGy8h7Q6vMoBIaeSFaCr
 U8cks6S5cgOCo2InS2JBu4KGdmB7LOLOT3RkHZvGIUk/jWpvXWkeOh4/C1iP29pNdoBcD7tJ
 kTUvGt5vcILZCv6MfUnP8ftW59yiPGlGtX5E+vZaNYLb514dQvC4yhofUOW0CbpkWAslr06M
 JafN82rCB4yCrpiiT2pQeoH+bwm3CYzwSXUX5+T5wyuzbGee3mPSvIGLl6mdukl56Obpx/Wt
 dVSLc2Hz1NYSuKWSize84kJIVcPKlAlCp3s7c9abOiOJkxhAm5JI/zPxJs/dIF/2adYjOHF+
 je6QEAw4Fnyn3vKLQGVclhsbbruWdB0qndTFS8yOBOvxH4ue66x46oFMZg6Z78q8Kpk1/EcZ
 /cfctiMGPlXTS7b+jISRZ/xrZckexO1wwuTVwK5JTQ2dZhtVkmTq/fkeRfq/SgKSCGwsKMDT
 6aIzluAHcJbG0J8FMCTZqrziV2x+HsaleZ0GUfFSjVORKny2ItrEXfPqN4yGtANEy/O7Gqwy
 AmtDj5N8IEhvLQJHMn1abGs9tn0QrcmQxMHRgE3/p7rbXmArzTLLZtoDrfYJGu1uHbcof3KW
 AlD8x3rGNEq9Lqgm7VxCK1myaM46LMDTJcHll80TR0ng3yNDal8IjG83chJu+hyy6RFoQu/X
 kOGkuS22Ill2+u8Tjb93CJ/Moy+OQg8w1E/LZ0deS0WHhNf8rudSll1NBKRkiFbJ7YdGNp7n
 LZ85ZdKsFHu1EFC3jO6YsZ8qDnkwpsoDP5Pi33mKNW31GLHN3kdMMyMW36siH1xQ4kdaxFzS
 tNruEYyr+4FnROZIytb+Ynl0edAmY8FuB1RhFEFPU+CmsfDieQx0QFDmQnbvSwKpiiqEotbZ
 ABWCqGCDf7Tomgx2JUSDzjE9sMoLETxx3EdAmAhzAXxJ3REnESXRIHhEY5hJHwkzl8=
IronPort-HdrOrdr: A9a23:rUvdlqBw2WCAk1zlHem755DYdb4zR+YMi2TCHihKJSC9Ffb0qy
 nOpp8mPHDP6Ar5NEtApTniAsO9qBrnnPZICO8qTNSftMyMghrMEGgI1+TfKlPbdREWjdQtt5
 tdTw==
X-IronPort-Anti-Spam-Filtered: true
THK-HEADER: Antispam--identified_spam--outgoing_filter
Received: from p034004.vpn-f04.fh-koeln.de (HELO MAC15F3.vpn.fh-koeln.de) ([139.6.34.4])
  by smtp.intranet.fh-koeln.de with ESMTP/TLS/DHE-RSA-AES128-SHA; 04 Aug 2022 04:41:19 +0200
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Description: Mail message body
Subject: Charity Donation
To:     You <mackenzie-tuttle@ca.rr.com>
From:   "MacKenzie Scott" <mackenzie-tuttle@ca.rr.com>
Date:   Thu, 04 Aug 2022 03:41:16 +0100
Reply-To: mackenzie-tuttle@californiamail.com
X-Priority: 1 (High)
Sensitivity: Company-Confidential
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_50,
        FREEMAIL_FORGED_REPLYTO,MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
  My name is MacKenzie Scott Tuttle; I'm a philanthropist and founder of one of the largest private foundations in the world. I'm on a mission to give it all away as I believe in ‘giving while living.’ I always had the idea that never changed in my mind — that wealth should be used to help each other, which has made me decide to donate to you. Kindly acknowledge this message and I will get back to you with more details.

Visit the web page to know more about me: https://www.nytimes.com/2022/04/10/business/mackenzie-scott-charity.html

Regards,
MacKenzie Scott Tuttle.
