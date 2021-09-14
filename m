Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4326B40BBC4
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 00:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235844AbhINWmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 18:42:42 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:32718 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235464AbhINWml (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 18:42:41 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18EKxjDC032082;
        Tue, 14 Sep 2021 22:41:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=P519gENyp78y7SSoIHntU8nofN+lEx/muKd47UBgYuw=;
 b=WQxLDNfd5kipxRmOMqzvKdEtQH52ePbhZSYsRpckR7qaYyWcyUog3hMDtwJvfH55NK2+
 zQBOCVr30sjgDa7TSxrs/ia7ubFeiMzBFqM8MYnjXNBsiJMNsj9aZHvzHBb2Khcwv5YB
 Z4AKo7wB2FWdbuhtp1DQ12xOyy8dvDMjVBj92ESt8BJt100mav3Sf4aiuYVmEGoojWor
 IZFVRWssbhnbwMaAjLHae3EKvQ1Sa6FwDbrA4LT+od+c5eq6oDcDqymG5T82KzR2ZWwO
 CvrDvr1YOs30d88MUYFD0+oBcagCk+CH5KAS+AEkUXVC8T9auhfNwG4hFZXWON3bTqGB Bg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=P519gENyp78y7SSoIHntU8nofN+lEx/muKd47UBgYuw=;
 b=e+ImRojRJ3cnY/rAPdBfh0r7zmvudKED7ytdiviTMmuNQvZHdUwn+ncBtMCtVEH16gsi
 9dwYBC0Yzj+cX52NxEsUQBneXyFBwo53zpCqVc1Hjky8mXljae5ow/szX6eJBGQP8S2M
 p5hYwCNa8gm/ywULnFgW1zp44MQSdGu78Pfm6fwC4r467Xk/IAWJKBdj/krhXPXgCrmE
 C1Aam9km4y1Flh0bqa3mZAF+1g8yTgl5eoVTaXuxZQ6QFEIagffgSDRrW7yNIiaeKhZt
 KpupXS0wwDehVEPagmNwL9V0T/q5QbooJH+4DIVQoQrZ6L82VBX3lLs4bkF6DlFWPt7h Uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b2p3mk68b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 22:41:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18EMePmj146141;
        Tue, 14 Sep 2021 22:41:15 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3020.oracle.com with ESMTP id 3b0m96yejk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 22:41:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAacMuwCzxlxdcP9/JTxdhn5TzHL8CcLNxc26t55aIJnwqI40xYWkNmTdd1sefs+mQXizcMqDlQl1tlQmtLNV67J83WVswGHd3d9lqtDsqGUWf1RI7z6+L92oSWv4hFkQ+gkZSIZcymFYQvthH4b9Q5KQw9o1WWhUriptFGyunQIM8HwkmSkgUjxmOVnT2cWaEk4atIY8g97mEcmFucYIAitND/njcaeBj4HDU6BCdC/PrEkjkf51JTb4k/aeB3RPchmgkcwi0ovdKeuEoxaWyFrr3bFIkMaAMZWVlAr0eNabn4F+R6KXcaNnk+psGlOGSYqPqTXHLd1t8x8rb0Ejw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=P519gENyp78y7SSoIHntU8nofN+lEx/muKd47UBgYuw=;
 b=C5DS7QliBQS5RLLUOBiYbN/r/GJu8rzea7g/n2oZmXdVUh/p+tsupftr2kim2BQTZmJLBCcT0uqBftbED4p3NIZvU6FoWZGGIhnIoVVfEOaaaDgT7DigtFJEPpfj+/q74fUZGZ32CSIlp7HMtHP9Ud9ZrUCvR+guTIEyVrsWkidrRurlwaG+bjBhw6iyAecz6XgYYJ1Aju0KBkWUDjNs4CtgFivj2EasMNiIaiN7ISO/DTOwr8Axrt1D5ImNFmQCKI7Z1Fdi85aWp12eDI6fvxsVbuUnvqngWXi3FAzkd/2VPM/OEO9ivAXll4ZWZOkeV6M8gPDq41oUTAhqknTiDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P519gENyp78y7SSoIHntU8nofN+lEx/muKd47UBgYuw=;
 b=rJMxJ43ZasHOHS8AsLzeUuRdW2u5Gv3zLIzeZ5+vfIEM3E7pg3fScUIaMLmX7y/pB1M5jkh8D2DD+FxSMfWHVHTSd47yhEM6+ECYChIRMFBdhr2c8I1RB0Vq6ZB9yBQp4MNpo2vF4+nFm0atnkoNOwLzaITpIoKUwviUjm7LesA=
Received: from DM6PR10MB4380.namprd10.prod.outlook.com (2603:10b6:5:223::19)
 by DM6PR10MB4281.namprd10.prod.outlook.com (2603:10b6:5:216::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Tue, 14 Sep
 2021 22:41:13 +0000
Received: from DM6PR10MB4380.namprd10.prod.outlook.com
 ([fe80::f4b1:d890:7745:30a3]) by DM6PR10MB4380.namprd10.prod.outlook.com
 ([fe80::f4b1:d890:7745:30a3%5]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 22:41:13 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     David Hildenbrand <david@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Subject: Re: [PATCH resend RFC 5/9] s390/uv: fully validate the VMA before
 calling follow_page()
Thread-Topic: [PATCH resend RFC 5/9] s390/uv: fully validate the VMA before
 calling follow_page()
Thread-Index: AQHXpZcUo4CShfRFgUS/m3/66qDGNaukKAiA
Date:   Tue, 14 Sep 2021 22:41:12 +0000
Message-ID: <20210914224054.pigma5e3dfyiup44@revolver>
References: <20210909162248.14969-1-david@redhat.com>
 <20210909162248.14969-6-david@redhat.com>
In-Reply-To: <20210909162248.14969-6-david@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6144b58c-5ea8-4b9b-85a4-08d977d0c165
x-ms-traffictypediagnostic: DM6PR10MB4281:
x-microsoft-antispam-prvs: <DM6PR10MB42813F9FF7C1473B017408A3FDDA9@DM6PR10MB4281.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:187;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oBcpPB/GzwLTLBQzv2BFrFnrdxDiG7uPkYfTkgD9XlABsWGGFv5+HqKXHP/GTLFQjx//hCnadu90zfC3GQ1LgRROU03uIg94U9QWXTDpqrswgALZRnu+kI/ZFEnwmq5fw+9zebuRmK4t8ISwHdkAyWhRKQsVZlvisZ3khkK1cCvb5ZThduTlUtnIbysUuvV++KJmtB0dqfVe+nuTyvZWw4W7Fuwa4gy+XCsdXg50khxNZ6R5zXcYCwAqfhoXOxoQJpJ04vWmaeF2IW04P/izC2UaSIzsLwo89sada54WPC6TISGyOhMliyICuq27ZiOoF59aB5YPJuwKExfnWq63LOVNy53JsDV6K0sQWb7gPLP04SvOqckiKJgYUJiN3IjdfUcBiXSednRvL49nzSiECtoDtqweN+xPNU0Rar32IdgEFY0KCw5isAFxBnoY+GzTl3I1w7JuTvSmpBlZpOyDUdyQsI8iaLInAI1VQENXPUKmZH9H3tJ72qodHTGundZ7YVfYWtwP4erFIHKrMEpOl7Gc9uS9xeXuzyhXgVWIetih37ZjeL4xyGqHozoTi8CEjTiVV3rmj74fmtBCXsZIJFQGY1TtXz/royZMhkPi4DVMX6n6oPnc4eLrdG1sS6twPwUQJrf1wU0cnRxFukqxkUxf3x5uIMqVETh9DsleKc+B/sYePKYxQ7zJmA27TPSZ8UX75EaU0vjPykGi5MNAbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4380.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(136003)(376002)(366004)(346002)(396003)(39860400002)(71200400001)(26005)(8936002)(122000001)(38100700002)(76116006)(91956017)(2906002)(478600001)(4326008)(66476007)(64756008)(66946007)(66556008)(6486002)(5660300002)(33716001)(66446008)(44832011)(1076003)(83380400001)(186003)(54906003)(6506007)(7416002)(38070700005)(86362001)(316002)(8676002)(9686003)(6512007)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vwSLcEw/yeD3GeTNt55HY7jFuA8lj66Kdtem8wB503wXBEhXM65yb/QEhG9z?=
 =?us-ascii?Q?e2N+GCt6DGkDkmEQSoNq4djMENqle7MIjOhoGOQOSehHfSpZVntsU7V85Yzi?=
 =?us-ascii?Q?rwjt7DRYerTyccnuYKC60CUNPKs/fzfSHGtTnLVTPu4iad7g1ETFGRD5BRWN?=
 =?us-ascii?Q?BH30hlCF8gbByt9RksZT7JBVbvdTjuTHYM6mErM3Qa40Zg/Ezv3MN4ub7G9u?=
 =?us-ascii?Q?y3WPvCG2xvAI3IImTQxESYYg3T+HONCgByrzmi9OX+EfIBhuDONWia3oUFIh?=
 =?us-ascii?Q?LeY7G4wXnC50Mcokf7Jm5KazXfa9MbbfjAOlAJ3jmH+BoE1WFsJ9Hr5I7xDt?=
 =?us-ascii?Q?MAHU1RBcQdeu71XJZWz9cQUSGx2cOsjw/wXARAf6fFPDeXsoTZtmsSlc8OeO?=
 =?us-ascii?Q?vNXHcHbg+/ltSkhd2iX4uuUSsTBfKud8eR7oecjXlpUHhYe6WoRohKKNvmW9?=
 =?us-ascii?Q?/MrzJ3+XydFRZ7H/Cx85ZlvnMEV4RQHeR6qsRs/ZygDgmrCL1IVSkx23wFyh?=
 =?us-ascii?Q?xucJ2YE2TEpfbpeYxIwHPF6LJ3IsiKXpCDqeMys0rqZ9dwQ+OIkAnlkcUSoh?=
 =?us-ascii?Q?l9bAW4KyWQUYTEM8EyIOpdQlP2Yl6Or/Dss3utftktd90nTj1aKgRhACWR0X?=
 =?us-ascii?Q?e+297NfKNoe0VO5WeT9wor2HXox3uTIY97MofWcP3MbmfaySApntrUYDku1f?=
 =?us-ascii?Q?tV+Xjf5Ea0twfkWR6kWjG9nhvw/h4WZEXR7+ted2TDVnYyrxK9kllymYoman?=
 =?us-ascii?Q?mUGZnUa89L8PRYawQhhoEQZPR7AXriYrIu//C3SDpya59PTuJiK4doUGvvTL?=
 =?us-ascii?Q?trSyl+hbLGdx+3ML1XXQrFivlXoOc3que3OGx1QC9Oy0q5IPwo4CpB91NwIF?=
 =?us-ascii?Q?BgGV3B+Ap2ltbVjJju2XivZDUPIw51mauW8gEX8bMWmpHJIduS5TYyrXIoWx?=
 =?us-ascii?Q?D8tBLcNZffTP1gAo9Qojl1MBe44Hgm14kGEL9Dd3KwBePFue0r/fru7pfzI1?=
 =?us-ascii?Q?dLA94VBsyXUPL6OgA+X4cIzCbtmEstwQIipX2IKQRZrk4si5bkNyV5P0aVY4?=
 =?us-ascii?Q?SRsnShzIDa8+wf/DOigKZOmnKAteYYyhhq4kIXc77CcVqDk2N2xf8otr+LpA?=
 =?us-ascii?Q?dplQMwXhy2YTRsyfzHrSNL8HwD97sLWIIcfq5rlf3eLCvkdQyRFYTrvIMx8i?=
 =?us-ascii?Q?T4wJnw1hO4KgEHeJW4pwQU1J/+e8H7eouSwUUVke3LelrTnuXAYZChgd7J5j?=
 =?us-ascii?Q?dzcATO7xyj6NUiVypFBFNmJ654wqsrEgtBC4NZpOVzNDbwMTeiIPmOJIJDAS?=
 =?us-ascii?Q?tzeaXXOHxgyrRv325hLZDk0l?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BD14D07FA62D744DAAB7F276B5C2EA9F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4380.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6144b58c-5ea8-4b9b-85a4-08d977d0c165
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 22:41:12.9980
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XhsgbE/g/FSxHCfL+S7RzSkAoS7J4GHfb/N5sfo65tpeEl8X1KxMJGXYedhWEFfxIGUeMKRnAHSrzuEV9vC82w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4281
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10107 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140130
X-Proofpoint-GUID: 5tLg38MzFuDpv98ARj5Pdo71E36w-hwA
X-Proofpoint-ORIG-GUID: 5tLg38MzFuDpv98ARj5Pdo71E36w-hwA
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviwed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

* David Hildenbrand <david@redhat.com> [210909 12:23]:
> We should not walk/touch page tables outside of VMA boundaries when
> holding only the mmap sem in read mode. Evil user space can modify the
> VMA layout just before this function runs and e.g., trigger races with
> page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
> with read mmap_sem in munmap").
>=20
> find_vma() does not check if the address is >=3D the VMA start address;
> use vma_lookup() instead.
>=20
> Fixes: 214d9bbcd3a6 ("s390/mm: provide memory management functions for pr=
otected KVM guests")
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/s390/kernel/uv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index aeb0a15bcbb7..193205fb2777 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -227,7 +227,7 @@ int gmap_make_secure(struct gmap *gmap, unsigned long=
 gaddr, void *uvcb)
>  	uaddr =3D __gmap_translate(gmap, gaddr);
>  	if (IS_ERR_VALUE(uaddr))
>  		goto out;
> -	vma =3D find_vma(gmap->mm, uaddr);
> +	vma =3D vma_lookup(gmap->mm, uaddr);
>  	if (!vma)
>  		goto out;
>  	/*
> --=20
> 2.31.1
>=20
> =
