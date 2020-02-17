Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645D4160882
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 04:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbgBQDMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Feb 2020 22:12:07 -0500
Received: from mail3.iservicesmail.com ([217.130.24.75]:56586 "EHLO
        mail3.iservicesmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgBQDMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Feb 2020 22:12:06 -0500
IronPort-SDR: DiUFmNEpF+RH2zAZZy73rUa6Odayg7ra41eD/0+8JW6M4RhmInEjUCbIu7Lui2KoLhpisfmvQl
 q7VGbkbsVLRQ==
IronPort-PHdr: =?us-ascii?q?9a23=3AvjpOQRb17ngVk8yuHRq+g+T/LSx+4OfEezUN45?=
 =?us-ascii?q?9isYplN5qZoMmybnLW6fgltlLVR4KTs6sC17OK9f+9EjFbqb+681k8M7V0Hy?=
 =?us-ascii?q?cfjssXmwFySOWkMmbcaMDQUiohAc5ZX0Vk9XzoeWJcGcL5ekGA6ibqtW1aFR?=
 =?us-ascii?q?rwLxd6KfroEYDOkcu3y/qy+5rOaAlUmTaxe7x/IAi5oAnLtMQbgYRuJ6Y/xx?=
 =?us-ascii?q?DUvnZGZuNayH9nKl6Ugxvy/Nq78oR58yRXtfIh9spAXrv/cq8lU7FWDykoPn?=
 =?us-ascii?q?4s6sHzuhbNUQWA5n0HUmULiRVIGBTK7Av7XpjqrCT3sPd21TSAMs33SbA0Xi?=
 =?us-ascii?q?mi77tuRRT1hioLKyI1/WfKgcF2kalVog+upwZnzoDaYI+VLuRwcKDAc9wVWW?=
 =?us-ascii?q?VPUd1cVzBDD4ygc4cDE/YNMfheooLgp1UOtxy+BQy0Ce311DBImmH53bcn2O?=
 =?us-ascii?q?shFgHG2gMgFM8JvXTMq9X1LrsSXvquwanVyzXDbuhW2Svn6IfSbx8uu+uAXb?=
 =?us-ascii?q?NsccfIz0QkCgDLjk2IpID7Ij+Y1P4Bv3WV4uZ8T+6jlWEqpxt/rzWvwMonl5?=
 =?us-ascii?q?PHiZgPyl/e8CV02IM1JdqlR0FledOkC55Qtz2CN4txX8MiX3lkuCYkxb0Cvp?=
 =?us-ascii?q?62ZC0Kx44mxx7bcfyIbYyI7g7sWeqLPzd4g29qd6ixhxa190iv1PfwWdev0F?=
 =?us-ascii?q?pSrypFlMfDtmwV2hDN98SKSOFx8lqv1DqTzQzf9O5JLVo6mKfbM5Ihx6Q/lp?=
 =?us-ascii?q?sXsUTNBC/2n0D2gbeOdkUj4Oio9/7ob677pp+aNo90kR3+Mr40lcOiG+s0KA?=
 =?us-ascii?q?kOX3SD9eSmyLLj5VH5QKlNjvAukanZrpXaKN8Fpq62HQBVyJwv6xWhADe81t?=
 =?us-ascii?q?QXg30HIEhCeBKdgIi6c23JdfPmCN+hjFm21jRm3fbLOvvmGJqeFHXblKbdeu?=
 =?us-ascii?q?NF5lJR0kIMytZQr8ZMB60MOu30XEDxt9zDBBQRPAm9wuKhA9J4gNAwQ2WKV5?=
 =?us-ascii?q?eULK7I+WCP4O1nd/GLfpMckCv7KuM5/ffihDk4hQlOLuGSwZILZSXgTbxdKE?=
 =?us-ascii?q?KDbC+0jw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2HOOABABEpelyMYgtlmgkOBPgIBgVV?=
 =?us-ascii?q?SIBKMY4ZsVAZzH4NDhlKEEYEFgQCDM4YHEwyBWw0BAQEBATUCBAEBhECCBCQ?=
 =?us-ascii?q?8Ag0CAw0BAQYBAQEBAQUEAQECEAEBAQEBCBYGhXOCOyKDcCAPOUoMQAEOAYN?=
 =?us-ascii?q?XgksBAQoprQ4NDQKFHoJXBAqBCIEbI4E2AwEBjCEaeYEHgSMhgisIAYIBgn8?=
 =?us-ascii?q?BEgFugkiCWQSNUhIhiUWYNIFqWgSWa4I5AQ+IFoQ3A4JaD4ELgx2DCYFnhFK?=
 =?us-ascii?q?Bf59mhBRXgSBzcTMaCDCBbhqBIE8YDY43jisCQIEXEAJPi0mCMgEB?=
X-IPAS-Result: =?us-ascii?q?A2HOOABABEpelyMYgtlmgkOBPgIBgVVSIBKMY4ZsVAZzH?=
 =?us-ascii?q?4NDhlKEEYEFgQCDM4YHEwyBWw0BAQEBATUCBAEBhECCBCQ8Ag0CAw0BAQYBA?=
 =?us-ascii?q?QEBAQUEAQECEAEBAQEBCBYGhXOCOyKDcCAPOUoMQAEOAYNXgksBAQoprQ4ND?=
 =?us-ascii?q?QKFHoJXBAqBCIEbI4E2AwEBjCEaeYEHgSMhgisIAYIBgn8BEgFugkiCWQSNU?=
 =?us-ascii?q?hIhiUWYNIFqWgSWa4I5AQ+IFoQ3A4JaD4ELgx2DCYFnhFKBf59mhBRXgSBzc?=
 =?us-ascii?q?TMaCDCBbhqBIE8YDY43jisCQIEXEAJPi0mCMgEB?=
X-IronPort-AV: E=Sophos;i="5.70,451,1574118000"; 
   d="scan'208";a="319345077"
Received: from mailrel04.vodafone.es ([217.130.24.35])
  by mail01.vodafone.es with ESMTP; 17 Feb 2020 04:12:04 +0100
Received: (qmail 18944 invoked from network); 17 Feb 2020 02:17:37 -0000
Received: from unknown (HELO 192.168.1.163) (mariapazos@[217.217.179.17])
          (envelope-sender <porta@unistrada.it>)
          by mailrel04.vodafone.es (qmail-ldap-1.03) with SMTP
          for <kvm@vger.kernel.org>; 17 Feb 2020 02:17:37 -0000
Date:   Mon, 17 Feb 2020 03:17:37 +0100 (CET)
From:   Peter Wong <porta@unistrada.it>
Reply-To: Peter Wong <peterwonghkhsbc@gmail.com>
To:     kvm@vger.kernel.org
Message-ID: <4792754.70566.1581905857499.JavaMail.cash@217.130.24.55>
Subject: Investment opportunity
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Greetings,
Please check the attached email for a buisness proposal to explore.
Looking forward to hearing from you for more details.
Sincerely: Peter Wong




----------------------------------------------------
This email was sent by the shareware version of Postman Professional.

