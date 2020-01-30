Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B29FF14DD47
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 15:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbgA3Ou1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 09:50:27 -0500
Received: from mail-eopbgr90070.outbound.protection.outlook.com ([40.107.9.70]:63027
        "EHLO FRA01-MR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726948AbgA3Ou1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 09:50:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b4SffOnQ9DMNNGy6aHebkzugMCJU0GOZcAWfphM+0dU=;
 b=WYLOHRfE7uZ2TpnsiYBk/Tvx4YJPZ9/0PAPAPWFpTFE+gv2K9x9IxW46qG0XWOqUIj6oWH8+x5Z9f5rNfQtP4tGAtOrAAdBTmCNCgZkr+tVBhp8Y+TOzBsvTTKbS7s4fqCaq8SHDzHJkYcvC2Mto1eUg7WO4oHkQV9X/4rFMsvE=
Received: from VI1PR08CA0128.eurprd08.prod.outlook.com (2603:10a6:800:d4::30)
 by PR2PR08MB4748.eurprd08.prod.outlook.com (2603:10a6:101:1f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.23; Thu, 30 Jan
 2020 14:50:23 +0000
Received: from VE1EUR03FT057.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::202) by VI1PR08CA0128.outlook.office365.com
 (2603:10a6:800:d4::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend
 Transport; Thu, 30 Jan 2020 14:50:23 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT057.mail.protection.outlook.com (10.152.19.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.18 via Frontend Transport; Thu, 30 Jan 2020 14:50:22 +0000
Received: ("Tessian outbound d1ceabc7047e:v42"); Thu, 30 Jan 2020 14:50:22 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: cdccfbc10ada971f
X-CR-MTA-TID: 64aa7808
Received: from d1d2f9d06b7b.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id CB823847-3445-46FB-ADC0-EBC845D959ED.1;
        Thu, 30 Jan 2020 14:50:17 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id d1d2f9d06b7b.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 30 Jan 2020 14:50:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ff3M7+C5ZYSHm2LL7ZpzESbUd7v7Aq+Co+l4ORSJV91TpT3UIn9IZpQ1zSCWa4VCOTlFV7Feu3Y0/jibGcIVkMzg5GGq4JmyHheUTC0waoWUaZwbV7pFhaK6He6SXFRE/RCe7PWhJ+VudZlJnr9lhnyjALnahuv6heG6Wg0BQFny9uM0dh2Tim5QdtXLJo1TpzNviuGJ4V6gh9o7T3z9/x3Hhfgn5tE/h3gJktR0yZQXVX5jRxuQIup4rwLc34oBxvR2aFMq8o49w57+ayZy1/zjaejNGr0lz9fg0QTLYY0EP9Zb9hO9qaw0UorPNaFfInfNuqc4o3WnH/+X5S86yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b4SffOnQ9DMNNGy6aHebkzugMCJU0GOZcAWfphM+0dU=;
 b=GQSe9Zz5/7QzEuElt+y/F86ZL4D+ho4XqrLFl01vOTdndAbK2xoD8ei/OrBX54SgKtJrmPO8LCTis2NhH9vXl+vENy3pgjeFUEcPhzoW0ILvZLvuREpe9B3iuGRV9GGAgV+6VdF8TYDluC/Aey4rRsRIsBEsSQJDQKE/m8MLQMAgcnPGVP1dOYWXJGYOZaNLEw3uuBzxV13LHBc47m8laArL8M9jT7CQ+N8MDC8FxNg78qQ+bbURAUj90M/dwrrgWWGTCx2jH8eAt+CZIreQBncZl7fG2DYTnwYdmKQEfUXRoQGAq23tm+jp28ixZ6NEPn0deebvAo3lO/65YzRcTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b4SffOnQ9DMNNGy6aHebkzugMCJU0GOZcAWfphM+0dU=;
 b=WYLOHRfE7uZ2TpnsiYBk/Tvx4YJPZ9/0PAPAPWFpTFE+gv2K9x9IxW46qG0XWOqUIj6oWH8+x5Z9f5rNfQtP4tGAtOrAAdBTmCNCgZkr+tVBhp8Y+TOzBsvTTKbS7s4fqCaq8SHDzHJkYcvC2Mto1eUg7WO4oHkQV9X/4rFMsvE=
Received: from VE1PR08MB4669.eurprd08.prod.outlook.com (10.255.113.215) by
 VE1PR08MB5277.eurprd08.prod.outlook.com (20.179.31.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.27; Thu, 30 Jan 2020 14:50:13 +0000
Received: from VE1PR08MB4669.eurprd08.prod.outlook.com
 ([fe80::fdc3:5fb0:d0b4:ef3a]) by VE1PR08MB4669.eurprd08.prod.outlook.com
 ([fe80::fdc3:5fb0:d0b4:ef3a%4]) with mapi id 15.20.2665.027; Thu, 30 Jan 2020
 14:50:13 +0000
Received: from donnerap.cambridge.arm.com (217.140.106.55) by LNXP265CA0085.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:76::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend Transport; Thu, 30 Jan 2020 14:50:13 +0000
From:   Andre Przywara <Andre.Przywara@arm.com>
To:     Alexandru Elisei <Alexandru.Elisei@arm.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "will@kernel.org" <will@kernel.org>,
        "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
        Sami Mujawar <Sami.Mujawar@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "maz@kernel.org" <maz@kernel.org>
Subject: Re: [PATCH v2 kvmtool 12/30] vfio/pci: Don't assume that only even
 numbered BARs are 64bit
Thread-Topic: [PATCH v2 kvmtool 12/30] vfio/pci: Don't assume that only even
 numbered BARs are 64bit
Thread-Index: AQHV0fPV+P82RczRvkSM25vknI1J46gDVSCA
Date:   Thu, 30 Jan 2020 14:50:13 +0000
Message-ID: <20200130144947.2d02c2b4@donnerap.cambridge.arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
        <20200123134805.1993-13-alexandru.elisei@arm.com>
In-Reply-To: <20200123134805.1993-13-alexandru.elisei@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [217.140.106.55]
x-clientproxiedby: LNXP265CA0085.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::25) To VE1PR08MB4669.eurprd08.prod.outlook.com
 (2603:10a6:802:a8::23)
x-mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Andre.Przywara@arm.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9c5b69ba-842a-41a6-f835-08d7a593bc03
X-MS-TrafficTypeDiagnostic: VE1PR08MB5277:|VE1PR08MB5277:|PR2PR08MB4748:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <PR2PR08MB4748103DB71459D7A3A71F399D040@PR2PR08MB4748.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:2000;OLM:8882;
x-forefront-prvs: 02981BE340
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(199004)(189003)(1076003)(5660300002)(55016002)(6636002)(64756008)(66446008)(66946007)(26005)(66476007)(66556008)(44832011)(86362001)(956004)(71200400001)(4326008)(186003)(16526019)(6862004)(8676002)(81156014)(52116002)(2906002)(8936002)(478600001)(81166006)(54906003)(7696005)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR08MB5277;H:VE1PR08MB4669.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 3zZVkm7EYiLOYyg5biNtvn27Bzi0B566zL2uRpfQNdPZnjBEJ79M/KeBN5AXQabCEVrWcnMZI41I41GSW/yAi8hvVcyl0Lo/MS7+MjBTn32LYvUbpVktNkht1lYukVodkb/ZqsJdHrl9z9U0y19o+WZtOiTv/ZVS+wxyfkhJrzt6HG702iSxoAkMlji3aGI/AnpWnLsycNdovtJfD1Vogwh/p3z97qDupI9YHG1O6dZzk/Vh16vmTWOS+iXaiJo4dnV2dYq+JHXXktQjlbfbqFv4yDeO64I328MfO/F7kRWKCLGxjnAEYupkNdAX/cPaEiKyIQIl9ncjqxyHOwWkshrBPTjREfyrpgf0FPfMX4QbsWB94BGHanpRBh19v8JjKng0eyFRcSULtmc+lwuikS0hrBI4pgGI/BKNYMHbeqU9hMlMTK/x2YRLPQRsEh1a
x-ms-exchange-antispam-messagedata: Fcfiu8QnL+1YTw63IGUxf32v242LvjOIo671j5OJIlABIDr8q3E3lDOAfr7VJCroDpNuBhXfAkgeJIWGLfQS+Kns2UrfuR5rN0kE1tbvmvkI5MVMaIO9ME7JzzUGL1CWoym4LZW17FAQE4gv8n6SsQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <72119A5F5C55964B994A1DC2B881E7FA@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5277
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Andre.Przywara@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT057.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(376002)(136003)(199004)(189003)(55016002)(70206006)(16526019)(54906003)(26005)(316002)(81166006)(8936002)(2906002)(81156014)(478600001)(26826003)(186003)(6862004)(70586007)(8676002)(336012)(5660300002)(7696005)(86362001)(4326008)(6636002)(1076003)(356004)(956004)(36906005);DIR:OUT;SFP:1101;SCL:1;SRVR:PR2PR08MB4748;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Pass;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: eac62d40-1ee3-4fdf-bc6c-08d7a593b65a
X-Forefront-PRVS: 02981BE340
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mRgcXmOiwz5aBh2RYSsSisoPU6AJvOcSs12lwBueWdkteWfvjUz0wWq+Z9pZtRtFtCDLURgiuFH3rGmGDcnFYmZXRjcLC36OghiIATD391Du+zbheEQ4OJauEu7bcy/1HE4jkUgRr5P+y+UAuw17PnlBlFfR/clQnn9JojK7mHgN+m4+YOgfpWBZ9w4RSeqKQFr8ItlrEtAcyzXRgfPIHWE5mEBUk54eoSMhcK/EDhEHfFyv6ciauHr5FXVDvq45wH1e2qDkBsQnOyb3vv3dZThd8Ccw7UbbBfpsEjoDiro33bg87WcfuAyhhu9InSwGsv9sDTNRkG9BjUxW3jG03yoB9yQ10j94E9gRKy8SJaa/cXMSc8FlGlzbe020mHM13mfo5MzxMlxw/ihYmioxzzjdyn4kqwY4+DED/D2BQ42P4mCQjLAlIUNlBNrRUpZf
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2020 14:50:22.8175
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c5b69ba-842a-41a6-f835-08d7a593bc03
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR2PR08MB4748
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jan 2020 13:47:47 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> Not all devices have the bottom 32 bits of a 64 bit BAR in an even
> numbered BAR. For example, on an NVIDIA Quadro P400, BARs 1 and 3 are
> 64bit. Remove this assumption.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  vfio/pci.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/vfio/pci.c b/vfio/pci.c
> index bbb8469c8d93..1bdc20038411 100644
> --- a/vfio/pci.c
> +++ b/vfio/pci.c
> @@ -920,8 +920,10 @@ static int vfio_pci_configure_dev_regions(struct kvm=
 *kvm,
>
>  for (i =3D VFIO_PCI_BAR0_REGION_INDEX; i <=3D VFIO_PCI_BAR5_REGION_INDEX=
; ++i) {
>  /* Ignore top half of 64-bit BAR */
> -if (i % 2 && is_64bit)
> +if (is_64bit) {
> +is_64bit =3D false;
>  continue;
> +}
>
>  ret =3D vfio_pci_configure_bar(kvm, vdev, i);
>  if (ret)

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
