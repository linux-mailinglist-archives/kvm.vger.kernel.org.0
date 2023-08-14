Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7158C77BBDE
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 16:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbjHNOk6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 10:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232370AbjHNOkk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 10:40:40 -0400
Received: from rcdn-iport-2.cisco.com (rcdn-iport-2.cisco.com [173.37.86.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523D4FB
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 07:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2496; q=dns/txt; s=iport;
  t=1692024039; x=1693233639;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=gZraSbyyI8ym7OhAhiEYZCdsYRxnv160Qf5+kyXymz0=;
  b=EPNd30RhbYRujIIQSijVC23eyd6jAxPNJ/BX6hW+s+C+jLV9bPJ3uU1x
   PUoWPXsuMJvkoA+Eav9B4ov2gFy+pev4WlFwmgnM6FGbAIO5zZUh2LHSx
   LoFvXBOQsOmMcgFqcqM/7byXwSjBvIALLgvOcTupNEzFWY6LVQmgkJfAj
   0=;
X-IPAS-Result: =?us-ascii?q?A0AbAABzPNpkmIgNJK1aHAEBAQEBAQcBARIBAQQEAQFAJ?=
 =?us-ascii?q?YEWBwEBCwGBYFJ0AlkqEkeIHQOETl+GPYIjA4ETnGaBJQNWDwEBAQ0BATETB?=
 =?us-ascii?q?AEBhQYChl0CJTQJDgECAgIBAQEBAwIDAQEBAQEBAwEBBQEBAQIBBwQUAQEBA?=
 =?us-ascii?q?QEBAQEeGQUQDieFaAEMhgQBAQEBAxIuAQE4DwIBCBEBAwEBLzIXBAEBBQMBA?=
 =?us-ascii?q?QQTCBqCXAGCXgMBnRYBgUACiiZ4gTSBAYIJAQEGBAWybAmBQgGIAAGFQ4Q3J?=
 =?us-ascii?q?xuCDYEVQ4IwOD6CYgKBURGEEoIMIolthUsHMoIsinQqgQgIX4FvPQINVQsLY?=
 =?us-ascii?q?4EVgkcCAhE6E0pxGwMHA4EEEC8HBDIkBgkXLyUGUQctJAkTFUAEgXiBVgqBB?=
 =?us-ascii?q?j8VDhGCTiICPTgZS4JmCRUMNFB4EC4EFBiBFFAkHxUeOBESGQ0DCHsdAjQ8A?=
 =?us-ascii?q?wUDBDYKFQ0LIQUUQwNIBkUDRB1AAwttPTUUGwUEZVoFnlGBWQOCKRUGcTRyB?=
 =?us-ascii?q?gUGHpMOA5APoSQKJ4Nki36VPBeEAYxsmG6YKiCneQIEAgQFAg4BAQaBYzqBW?=
 =?us-ascii?q?3AVgyIJSRkPjiAMDQkVgz2GcYkIdjsCBwsBAQMJiHCCWAEB?=
IronPort-PHdr: A9a23:xTnZQRw8fEh5xCHXCzMRngc9DxPP853uNQITr50/hK0LK+Ko/o/pO
 wrU4vA+xFPKXICO8/tfkKKWqKHvX2Uc/IyM+G4Pap1CVhIJyI0WkgUsDdTDCBjTJ//xZCt8F
 8NHBxd+53/uCUFOA47lYkHK5Hi77DocABL6YAhtKPnzBojfp8+2zOu1vZbUZlYAiD+0e7gnN
 Byttk2RrpwPnIJ4I6Atyx3E6ndJYLFQwmVlZBqfyh39/cy3upVk9kxt
IronPort-Data: A9a23:oOAbu6A9uMZjGxVW/yzjw5YqxClBgxIJ4kV8jS/XYbTApD4i3jIHz
 2saDT2Faf3cNzfyeot2Yduzo08HusTUzIRrOVdlrnsFo1CmBibm6XV1Cm+qYkt+++WaFBoPA
 /02M4WGdIZuJpPljk/F3oLJ9RGQ7onWAOKlYAL4EnopH1Q8GH590UsLd9MR2+aEv/DoW2thh
 vuqyyHvEAfNN+lcaz98Bwqr8XuDjdyq0N8qlgVWicNj4Dcyo0Io4Kc3fsldGZdXrr58RYZWT
 86bpF2wE/iwEx0FUrtJmZ6jGqEGryK70QWm0hJrt6aebhdqnwYj3/keK/0nc0Z0pA2Qs5d7j
 8tIjMnlIespFvWkdOU1Wh1cFWR1OrdLveSBKnmkusvVxErDG5fu66wxVwdtY8tBoaAuWj8mG
 f8wcFjhajiBn+yrxq69R8Fnh98oK4/gO4Z3VnRIlGmAUq93HMCfK0nMzdoAgDsQged/JPHfa
 PYdRBcsUTH6JAIabz/7D7pnzLv32RETaQZwq0yQjbQ47nKVzwFr1rXpdt3PdbS3qd59l0Kco
 CfN+H70R0pcP92Ewj3D+XWp7gPSoc/lcLs4BbDn0+Ftu0eS5UMrETFRXxylpMDs3yZSROljA
 0AT/yMvq407+0qqUsTxUnWETJis40V0tz14TrNS1e2d9kbHy13CXjleHlatfPRj5ZFoGWF2v
 rOct46xbQGDpoF5Xp50Gl28hDe2NC59wYQqOnJcFVFtDzUOXOgOYv/nR9JnFuu+icf4XGq2y
 DGRpy94jLIW5SLq60lZ1Q6a695PjsGWJuLQ2ukxdjn6hu+eTNL9D7FEEXCBsZ59wH+xFzFtR
 kQslcmE9/wpBpqQjiGLS+hlNOj3tq/UbWSA2gIyTsFJG9GRF5iLINA4DNZWeh8BDyr4UWSBj
 LL74FkIv8YDYBNGk4cmO9vZ5zsWIVjITIS5Ca+8gitmaZlqfwjP5zB1eUOVxAjQfLsEz8kC1
 WOgWZ/0Vx4yUP0/pBLvHrd1+eFwnEgWmziMLa0XOjz6i9JyklbPF+dcWLZPB8hkhJ65TPL9o
 ogGZpfUkUwAOAA8CwGOmbMuwZkxBSFTLbj9qtdccaiIJQ8OJY3rI6W5LW8JE2C9o5loqw==
IronPort-HdrOrdr: A9a23:mQf07q/5yBq3k3sJ5Kxuk+Fpdb1zdoMgy1knxilNoENuE/Bwxv
 rBoB1E73DJYW4qKQ0dcLC7UpVoMkmsiqKdhrNhcItKPTOW8ldASbsD0WKM+UyZJ8STzJ856U
 4kSdkCNDSSNyk3sS+Z2njCLz9I+rDum8zY5pa9854ud3ARV0gK1XYfNu/vKDwOeOAwP+teKH
 Pz3Lsim9OnQxkqR/X+IkNAc/nIptXNmp6jSwUBHQQb5A6Hii7twKLmEjCDty1uHQ9n8PMHyy
 zoggb57qKsv7WQ0RnHzVLe6JxQhZ/I1sZDPsqRkcIYQw+cyzpAJb4RG4FqjgpF4t1H22xa1e
 UkZC1Qe/ib3kmhPV1dZyGdnDUIngxerUMKgmXo/0cL6faJNQ7STfAxyr6wtnDimhIdVBYW6t
 MT40uJ85VQFh/OhyL7+pzBUAxrjFO9pT44nfcUlGE3a/pWVFZ9l/1pwKpuKuZ3IAvqrIQ8VO
 V+BsDV4/hbNVuccnDCp2FqhNihRG46EBuKSlUL/pX96UkcoFlpi08DgMAPlHYJ85wwD5FC+u
 TfK6xt0LVDVNUfY65xDPoIBcG3FmvOSxTRN3/6GyWuKIgXf3bW75Ln6rQ84++nPJQO0ZspgZ
 zEFEhVsGYjEnieffFmHKc7hywlbF/NLwgFkPsul6SRkoeMN4bWDQ==
X-Talos-CUID: 9a23:5OLPkG5G1IBkFCxO1NsszWQFF58AbXrm1nbzDHehJSFjD6OQcArF
X-Talos-MUID: 9a23:NqdvzghI3RBWTCNFqHF8xMMpMZ8074SpL3E0lpQJh82pGG9NHg3ak2Hi
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-core-3.cisco.com ([173.36.13.136])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2023 14:40:38 +0000
Received: from rcdn-opgw-1.cisco.com (rcdn-opgw-1.cisco.com [72.163.7.162])
        by alln-core-3.cisco.com (8.15.2/8.15.2) with ESMTPS id 37EEecRN014613
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 14:40:38 GMT
Authentication-Results: rcdn-opgw-1.cisco.com; dkim=pass (signature verified) header.i=@cisco.com; spf=Pass smtp.mailfrom=jpfuntne@cisco.com; dmarc=pass (p=quarantine dis=none) d=cisco.com
X-IronPort-AV: E=Sophos;i="6.01,172,1684800000"; 
   d="scan'208";a="253885"
Received: from mail-dm6nam11lp2169.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.169])
  by rcdn-opgw-1.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2023 14:40:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bsRNWnJcspG3ejw7TEEacSQyhWmB6ZWZVRtyY+Mn05G+ngrlTWj8Tg9VJySqdWuAc1JZAVqLAit6ys3y+TBUQarRewh+rUg82PblDKX72AAFiFfyq7avet/FdqSFvyJl5O/DG0I5dAQA1+XZB0pwKsuCNB+Sef4MLXbA5vv+37pLapC+SQpReP4AIoEv1DEm/pjfCg7u0HdtKNmu1KmpKrjBsjQGmuBAmp5182o/IulInFrsrxTG/vNsGNo+Eje7mUB8soav1yQ3Fi7xEscUbihOw432GThNJ1ipV+gMfJlgIEpuZpIxbasdC2wjG9fzB482I51sifUwQE4vuF5+ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wBclUTxBWEOEKwrJF4GziljXp3M/2xhG6qBBmWS3aGg=;
 b=oX6mZ0RUGGpaaSBJbxcZydcar85c2H2zfZ6u3pRVWBSVUWZi8lZhZlRjeUqVmF5cvj1q/8ojh6f+ZyWXZ7hYvfXShBpgbeDaSGcmepZtZ64yKNklENtKxtLCzI+dlnkQtBsGNfZrkYT9tcHfXzQjKac+7KeZgkk/PbV5oc7jfApH/zR91s9eZ4WDuM/uAgjGt7JMnlES5Zf8gTdloH7d6E83gIyhJ5NRQpJLiinYzpWnCXGKGSHgM9qhUl4oDoyaU7Z/sjadsbCDh/Oe0lP0ijun121wRmsLs8ePu/3aucEU50nPia5TCPoO/3RFTmgSDwYwuhti3vuyeQy8WwOsJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBclUTxBWEOEKwrJF4GziljXp3M/2xhG6qBBmWS3aGg=;
 b=MQ2nHYrITs66GjBDlOS1ORW+2d+97T9C0Diky09VP3LGHTzca3iQZ//Jwao28GledXi+e5VYZGwh+dLCNKlNUhrNoBiKrV2FitdV1oftMd3y8gFaJ8omdIS2myCqU/JEpVJXYT59AjpQbuMxAK5QClyvVbV8TbNX+TLHeo3omtY=
Received: from BL0PR11MB3188.namprd11.prod.outlook.com (2603:10b6:208:61::27)
 by PH8PR11MB6904.namprd11.prod.outlook.com (2603:10b6:510:227::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.24; Mon, 14 Aug
 2023 14:40:36 +0000
Received: from BL0PR11MB3188.namprd11.prod.outlook.com
 ([fe80::bc55:5f52:60c7:ceb1]) by BL0PR11MB3188.namprd11.prod.outlook.com
 ([fe80::bc55:5f52:60c7:ceb1%4]) with mapi id 15.20.6678.025; Mon, 14 Aug 2023
 14:40:34 +0000
From:   "John Pfuntner -X (jpfuntne - ACTALENT SERVICES LLC at Cisco)" 
        <jpfuntne@cisco.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: FW: Need help/advice with CentOS 7 arm64 container on Ubuntu 22 amd64
 Docker host
Thread-Topic: Need help/advice with CentOS 7 arm64 container on Ubuntu 22
 amd64 Docker host
Thread-Index: AdnLqvvtscpeFAccS4KPfe4X9F6ZvQDEhnTA
Date:   Mon, 14 Aug 2023 14:40:34 +0000
Message-ID: <BL0PR11MB3188B0B8101832AF2F9FC955D817A@BL0PR11MB3188.namprd11.prod.outlook.com>
References: <BL0PR11MB3188DF9F13A59E6E8EE4B43FD813A@BL0PR11MB3188.namprd11.prod.outlook.com>
In-Reply-To: <BL0PR11MB3188DF9F13A59E6E8EE4B43FD813A@BL0PR11MB3188.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3188:EE_|PH8PR11MB6904:EE_
x-ms-office365-filtering-correlation-id: 89859303-ec84-4876-ed94-08db9cd46ad8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lYRz1+ZbYdKR9SvCONVHsfcqB+Ide8ips4Qkxe3EtbyOnftV6ELzWUnmgWFACtnjLYHN+XgCR2V+cO7N4Ptjo9MeBcZXtaeGA9lBseYfwoFl2q5NG0ZRZn9p+jxWDFCNimgTqjNHSRwVtGc+2KQ5J3mPt9laMXu7TEt/n+OwIbR+P7WeOtE305ZBQMSSLFp2t7OfSprjz7pLWN596c3xJXZnLexvBTtl7Ic1bBZLNmzKreDkEXF6gKgT46GUMsg7BkjqURbErj6m5/5ULGq5S1aAGsCB4pb7wkNF1n31kN3K/bSKJA1L5qK7GmUSRPlX8CU7HTTLyIEXHODik0QGsapeDtiXe/I4qa/j3AwD2ZiJW0/R8F5s70f+oWV5U7n5U2dA4ZpIwIxyTCdTQWe2imf6HvtWhfiKZIUyhGvj8j0xptgx9ACHKbg3/YyN1gtPgTxrTLIT0p5QB6meQ/RSTENaqGKfFOcvJQIWsFOdYlazq+PyqonECc6z9q5kfH4tETjNd/MMcC+4PyxdRLKiRGGr7wjgz7Rb+57YQLTUvnTjK9SxWcT1SfImSAgNj0rjE28NIjp/GygnixO7gaFFaLoeMkFQGEviEUqY/LgDvvbKhn89a5/S8lAxxwvdx0Vt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3188.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(376002)(366004)(136003)(396003)(451199021)(186006)(1800799006)(33656002)(52536014)(5660300002)(2906002)(86362001)(55016003)(83380400001)(66946007)(66556008)(6916009)(64756008)(66446008)(38070700005)(76116006)(66476007)(38100700002)(316002)(41300700001)(26005)(9686003)(53546011)(6506007)(7696005)(71200400001)(8936002)(8676002)(478600001)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?sCYKQjujvTw9W2eOrfylhTTASOyS+cswhEv7N7sN6KSw+ivUZY8YuluriS?=
 =?iso-8859-1?Q?Qlp9cF2Dp5sWdGYhPguBhGHPwzQxVEJ57DxdFxup2TDINs7ipGJHi5mwMR?=
 =?iso-8859-1?Q?mteaba6zvvCURm+BLahmUujLl8uqxpewgmkH3M203O0X9efE9HfTD891Mt?=
 =?iso-8859-1?Q?vQQLwZT8mfmqVqfS1Kpi6Avu0Y4mtVE9wo01uRT5knnkuodB3RwAhO/hze?=
 =?iso-8859-1?Q?Z/4HatwWSR2KPFobSKtBBFGm18LOHFehOiAvPpIZeXsi7yV2vZpgU6f+XM?=
 =?iso-8859-1?Q?SceoK1887rUvgm52U+Qrrz4UNtn2aKq30FkrsWY1SpCw2ojaVcN7SjM4xX?=
 =?iso-8859-1?Q?K9XRMsUs0LO4G0FXPw5GXgVs8/Nm7ag9HpeNyrA8Zrg8Bljd05Xe1DO8Xr?=
 =?iso-8859-1?Q?um5tow3hVcVICGbetUgYQDQv8aGcbS+ardnGAw5gpsEqJVbR4ObIUcjAfU?=
 =?iso-8859-1?Q?WqoUnHbLTT7xAUPpbzE/8SJL4/ehGQ6gJ0mxDr0ouv9HHQb+buYAIdgkbD?=
 =?iso-8859-1?Q?uQzIdDznjDEtCPJEkuVkg2iE/Q9rrlTRC/+aTHpKASsCZeSyYpGKbJkXfG?=
 =?iso-8859-1?Q?hy4G56S0QaADlxv7finWD9kD0mzMTc7coDTPrFfl8XYRDPRTCgSU7vmSaX?=
 =?iso-8859-1?Q?Q86qI4ewTz0Vc1NEcGvUjo4I/B7GgDtjGTskht15jhhObY/btJ1q2F+Qjm?=
 =?iso-8859-1?Q?jmnGUUUyA11q4xc4rqn/+1wBx57PZNcbl8XbbKe28HSDjiN9q8gzvZv+KN?=
 =?iso-8859-1?Q?bkvChMEss2MKvX72kjtMwbNrEBUSuS73zJVAuLIiCFuhuBzNmrmzFqcygB?=
 =?iso-8859-1?Q?CRouS6WbmfENCV8IwVqUyjb/CBi+GmhsmbwMt/6v3Q8JvEonfweWix/gLb?=
 =?iso-8859-1?Q?dRAzzK/2oApdgMcuOHGhQprnGZ8wrq7nZvAH2rpyBeA/sbQf2PLVGcrJcA?=
 =?iso-8859-1?Q?hTQJ8R+W58SIZTtnpHI/CkF0yKd9814dse1OzowZWMiRnkAhSECVg4WFK7?=
 =?iso-8859-1?Q?m0ffgI3jTIr8/fkYo7XxCPLK1tYzAttPzGrFo2f2nZ4CLe6QW6X3dDHjjy?=
 =?iso-8859-1?Q?1C1I3Q3n8K//X4YIu/Vz8u8RTlfdGrwUVtDKZnJjeW4qwUOzBvTWYlNwxP?=
 =?iso-8859-1?Q?qug0Zt9N4RQg/XXexXVJqMzZeeqvJ4mh2Cnu+IHH/1/+Q43KGJhIKq8jq/?=
 =?iso-8859-1?Q?jVP0r2NToP/3mgv2K5gdx9/d13IaF9gyk57BnpsVb8pHyjqVpxF+kecG+L?=
 =?iso-8859-1?Q?3qxVl5q4PEhIs9TaTyXcQ8KZeZqQ919xP0pBw6qdFiUtGbqiDW/O4LlM/w?=
 =?iso-8859-1?Q?nxHc9eTeqp5VzwLTc0Zmi4h/c/ZLwbUHgQvNX3aqwXGW9YzyJ+f2voD70P?=
 =?iso-8859-1?Q?eHLD6Y7QbKulWF1CG2AoUzI/FI1eXKqPPi1nuAlz4Cmw4AzEmaeQw80dsW?=
 =?iso-8859-1?Q?lnd9RNRJ8LTa7PPNwVuh3Khb643r86Ovoumg76dJjwTTFKZtnQWBpYsvQY?=
 =?iso-8859-1?Q?Z0USE/j+vtzLu3Bh8jzYXBjm11VOY/d/MXeCjaXBksjdf8gL27bzqNzUgw?=
 =?iso-8859-1?Q?VEgBzDtiAWQiIFvLgKr0jZ9j6HJmHKQ9d5dwlc4eyinvqaMkw5HaMvvC7M?=
 =?iso-8859-1?Q?jaOCnCjVkQrG4=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3188.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89859303-ec84-4876-ed94-08db9cd46ad8
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2023 14:40:34.2429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JXoOkkedbvNHdt9Z+JdZbxm21q28VSWz7hRSGmi5I1WHR9kFQNGMnzP9NXG21KXdyAPAPLtZXxnc/o8xf0wwdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6904
X-Outbound-SMTP-Client: 72.163.7.162, rcdn-opgw-1.cisco.com
X-Outbound-Node: alln-core-3.cisco.com
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIMWL_WL_MED,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'm thinking of opening a QEMU bug I'm not sure if it should be in the kern=
el's bug tracker or QEMU's issue tracker.  Can you please advise?

From: John Pfuntner -X (jpfuntne - ACTALENT SERVICES LLC at Cisco)=20
Sent: Thursday, August 10, 2023 12:53 PM
To: qemu-discuss <qemu-discuss@nongnu.org>
Subject: Need help/advice with CentOS 7 arm64 container on Ubuntu 22 amd64 =
Docker host

My team builds several amd64 and arm64 Linux container images daily and lat=
ely we've been having trouble with the CentOS 7 arm64 build hanging.=A0 Our=
 build machine is an amd64 Ubuntu Openstack machine running Docker and we u=
se QEMU to run arm64 containers.=A0 We recently upgraded tooling to:

. Ubuntu 22.04.2
. Docker 24.0.5
. We're installing these packages:
binfmt-support/jammy,jammy,now 2.2.1-2 amd64 [installed]
qemu-guest-agent/jammy-updates,jammy-updates,now 1:6.2+dfsg-2ubuntu6.12 amd=
64 [installed]
qemu-user-static/jammy-updates,jammy-updates,now 1:6.2+dfsg-2ubuntu6.12 amd=
64 [installed]
qemu/jammy-updates,jammy-updates,now 1:6.2+dfsg-2ubuntu6.12 amd64 [installe=
d]

We start the container with the centos:7 image which looks like it's 18 mon=
ths old.=A0 The problem first manifested when doing apt upgrade -y in a Cen=
tOS 7 arm64 container and I've tracked it down to this command command:

/lib64/ld-2.17.so --verify /usr/bin/true

The command seems to be taking over the CPU:

[root@83d610f0f031 /]# ps -e -o pid,ppid,etime,time,state,args
=A0=A0=A0 PID=A0=A0=A0 PPID=A0=A0=A0=A0 ELAPSED=A0=A0=A0=A0 TIME S COMMAND
=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 40:35 00:00:00 S /u=
sr/libexec/qemu-binfmt/aarch64-binfmt-P /bin/bash /bin/bash
=A0=A0=A0=A0 35=A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 38:50 00:38:28 R /usr=
/libexec/qemu-binfmt/aarch64-binfmt-P /lib64/ld-2.17.so /lib64/ld-2.17.so -=
-verify /usr/bin/true
=A0=A0=A0 140=A0=A0=A0=A0=A0=A0 1=A0 1-00:03:13 00:00:00 R ps -e -o pid,ppi=
d,etime,time,state,args
[root@83d610f0f031 /]#

The same scenario doesn't happen on our previous build system using Ubuntu =
20 (qemu 4.2-3ubuntu6.27 and Docker 24.0.5).

I also did the following scenario:

1. Started an AWS Ubuntu 22 arm64 instance
2. Installed Docker
3. Started a CentOS 7 container (native arm64 architecture)
4. Observed the command did not hang

I don't know for sure this is a QEMU issue but it's a candidate.=A0 Can any=
one suggest further paths of investigation?=A0 Should I open a QEMU bug?

