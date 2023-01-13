Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08EE166A0AF
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 18:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjAMR0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 12:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbjAMRZ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 12:25:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23638B511
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 09:15:08 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30DGuCJN009203;
        Fri, 13 Jan 2023 17:14:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=vfBsXnumfB5/GOW4b+pqMiwsYETK11bYzr2lGViIQ/M=;
 b=fq+PHoJGKaxhrSKdnT6h/YCRGB9tp60gkHrsGu0DBJgC2Bknz89e6pkz7NwixWRxf2Aa
 tg3GFph0q7Tao1Pt05lBAoqXLhiz5T7t/WbPnovT3YmdeyZdlbjtebiTov01S2OlxrIX
 RMPqnOwuX281B9w4ob/uz4vKdr2XGwRt4MtU9XDVd9vCtioebl4wTBiC0qW3cq6vvAHW
 3xEwOf5Sng4qsaYe3xUz6zjs3OIPwD/CNDCwlzokiUy4LYzKNjs2iBAkq4WtlPI1Smud
 z8ktV/crdOxL5fiHOAjld8bOgUXv823BgvxG4tuPHni5qwI/MjpDa4aZEeuD4Y2Y2saz Vg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n39528cb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Jan 2023 17:14:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30DFd4xK011651;
        Fri, 13 Jan 2023 17:14:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4gxmp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Jan 2023 17:14:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIOgL2ErwcPurtAC9Fvl0MCorTSLL3qm977nhgw1OPiYPoLRPbuc8CEtKCJRd4pKswraCwZJKjEVi6tRvzfuxXLjsb5OLT6Bb2pitZezse6d8Jioj50jed6Z3A9c3lafxOpfahBg7XucPyFo3+TYrfkCih7BnhIwkOAvXt9016H6x8DL/lAbgapYsgSeno/ck/hW1gGovK0HCoql8eNq6AfZlZUFY4xBaiudIDeSimLjN0S/hUno/tQ3iqQ4VO9pQbO5B0ZZFqNoXc7+UH+WUCT+GiTvLagYHyXl39a9uD/bZpgcZg+Q0jPbiVSwss6QV+ALk8KOlqokLdhZDjT2rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vfBsXnumfB5/GOW4b+pqMiwsYETK11bYzr2lGViIQ/M=;
 b=RnV5TMmcORY38oD4oGU/zJjvxyVfVZSr0bAWGE81Wo0kt9iJGd5bS6r3dOuXPWDZACj7LJcWRaydB9jQ7/kYEkrOn9tvarsCM+vWhAG1EAnpzDYFA2r8uqLcRZfTuF/pPRxIipBdO88DJKVQCQxJdrojZ5yLW20VxL5K7wJeHlMEYrFbq1bL9ftjnGtjQLFgkCYGYA1yET3T+guaW58v3C3vXZnQA6hZ5p3VhJA3CcewKRSDK29slkcEm4CjfvCuJQVeyYmRQEcSweSqnN4WbV+JeUu91nbu5MN5AgfXkcysA5JDhkE/F5wPSSRRU+h4VdjrRZXugHtEYdgYlc/HQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vfBsXnumfB5/GOW4b+pqMiwsYETK11bYzr2lGViIQ/M=;
 b=xRlhu4f2is9/yAYpRdOn0dNONDcaLeejJVlH0DRGJ8w35LZepYFi2AWWX9b0IQi943c2xI30ik2QrquXCQEUCn4hOj2PFROEQmGZ27bAIELzkE3zUOupeJhw+miyxt280BDwGMw/+2sjf3/wY7Cc9EOv1bavws5JUj392243GPA=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by SA2PR10MB4457.namprd10.prod.outlook.com (2603:10b6:806:115::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Fri, 13 Jan
 2023 17:14:46 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682%4]) with mapi id 15.20.6002.012; Fri, 13 Jan 2023
 17:14:46 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     Jiri Slaby <jirislaby@kernel.org>
CC:     Pedro Falcato <pedro.falcato@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        mm <linux-mm@kvack.org>, "yuzhao@google.com" <yuzhao@google.com>,
        Michal Hocko <MHocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "shy828301@gmail.com" <shy828301@gmail.com>
Subject: Re: Stalls in qemu with host running 6.1 (everything stuck at
 mmap_read_lock())
Thread-Topic: Stalls in qemu with host running 6.1 (everything stuck at
 mmap_read_lock())
Thread-Index: AQHZJZLE7wnGvcxcYkmTyh5912LaH66Z8PiAgABcKwCAAKDaAIAAFNaAgAGXCYA=
Date:   Fri, 13 Jan 2023 17:14:46 +0000
Message-ID: <20230113171433.vywn6viy5iiugywv@revolver>
References: <b8017e09-f336-3035-8344-c549086c2340@kernel.org>
 <CAKbZUD0Tqct_G9OcO8ocdH1J_YvLSEod-ofr97hsyoHgcvBwuw@mail.gmail.com>
 <7aa90802-d25c-baa3-9c03-2502ad3c708a@kernel.org>
 <17b584f1-9d3b-35bb-7035-9b225936fd23@kernel.org>
 <3da07f36-52ce-58ef-845b-67c98f78410d@kernel.org>
In-Reply-To: <3da07f36-52ce-58ef-845b-67c98f78410d@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB3022:EE_|SA2PR10MB4457:EE_
x-ms-office365-filtering-correlation-id: 3f4a0233-86e0-4f65-1a3c-08daf589aba4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m5ykf8qJEIBWv7TjgHdJlfLo85PgDtuFvhqtPw9IOytUeY88laBQMYuc/IkmPLwSjkAuWIEGmLvd7rubeA0I8QKkxkIYtOPb4SzE32+qSn/ZIqwGFaK4efiShJ3RiV4Vzz1eXTbHmF6djWXb/oxkvdHFKU9+UGF+13EmCGjw4aqLXXEUQ8C9IbhN/1Yx2u67Kz97XFLwokGGdbeT9hga+qnRUgXe9FXasNL3dfKf2BETxnEekXzMQJxg4ScDlq5luqBd3948+ty293L4//TGUoRil1WIs5rACId64SEOlQ7WQgZee/WfCXd/lKj3eIvVUH2Jkft7MvaMGcDPJ7Qy9m5ddM4h4pqV8cJjLtHwxuuXOg6k78tU5iL38fDMYYJZr71bGMlfHzx7oQkqFOmqhmvhfp/dE5HyqZ+yXPCijNm8zzHxfXrEmsXaxkJKenuLJ+JHJybLuZ4klTOuYzrbISVrwFToYYeRsHJ30BbqiLdOaWGXOzFvMqBdOQ46cbIOA/ek/FBUDHnoORqQrMaqawIM/an8HQRYef/isNHF+YPIlV3uQ9Ti1sTvZe5D+uZEvYk9/HitaHmg2+rlmOPVNMpnmBJt7yH96ujvuezdU9PlIno19Sk8AAYMBqXIWvS76tjRQhGS8Mj9tl9DB73iOUv3em//kIKcWQjluD4z1+kix893QC0HfK2qMCa02Pwigs/Q+67ln08iTwE4hNTNNCzNT4EHMX4pTxbsh0c40F4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(39860400002)(396003)(366004)(376002)(136003)(451199015)(2906002)(54906003)(5660300002)(6486002)(4744005)(4326008)(7416002)(86362001)(44832011)(8936002)(9686003)(64756008)(76116006)(66446008)(66946007)(66476007)(66556008)(8676002)(91956017)(6916009)(122000001)(38100700002)(316002)(41300700001)(6506007)(966005)(6512007)(38070700005)(478600001)(33716001)(26005)(1076003)(71200400001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Woq3JBrHPlvKKPAaNDcMqyg9TV2i8ERVA0zSbRBDKP344/GS9IGQ4/JhDYru?=
 =?us-ascii?Q?IhW5HDXXaF4EEC33CWAnfkN/GGbUIzGSAzzn+MWsv9cuCSeDCU2wgy5Wdu21?=
 =?us-ascii?Q?TLZXJE2YJl5h9VJi/X82LheYodNoT/uzbzVJvE2VNaL1WFaOhWskWTLy34/V?=
 =?us-ascii?Q?+SiSNncs18P2ajFaV7MNESWVtiEEUpSgVPB0BvFRw2nqIfJBcvQLkUpr+xqo?=
 =?us-ascii?Q?7VqsQZDgxcOQ48Nk8iMLYZ5xQXqRXhGU1APpQt+gogX30cEoxQOT2DvMSfe+?=
 =?us-ascii?Q?o1w59m+5THcBkn+5KCFeKeiM6LB+2SKbFhLfCJGZiF+TeME6MTLDAAdddXLG?=
 =?us-ascii?Q?ztk07tfYIv1M+Cw8ipwqO0SrrNJTieBOGvBzMhUCqDBslTFmAxX1PxnwbVxb?=
 =?us-ascii?Q?h8j1psOvenCHYOS3BVAXS46djghwi3jNH8bolvMQxZqEZX+tsphQ88sU1iZ7?=
 =?us-ascii?Q?7KZ1Scn8BVpe0dCdpMqZaFRIsF1Zp7xv0swFsrsBKNPyLNjlzQXB7rt7n78N?=
 =?us-ascii?Q?1cy53NtaIm0l+fntjRDt3U+NK10w9maBmmlKd/RhOCUnpRhq45M5q5l6brYo?=
 =?us-ascii?Q?1PS7KTaSuvk0pIvJjSYWn4ICov3ttuzbi2YisurdcGTLPG9G4I+P/i/wXBhh?=
 =?us-ascii?Q?Qj+twY4xq+WWK4uIp1NfJ7gJglR9CVr0CGztmeUMXnOJlq8X4iFrZ49INEs4?=
 =?us-ascii?Q?+wnBIjnEmyoEWX+70njRQtSyQcp92Bw0S2kyJ3wDTHenARLwLN6/ouBxcE/G?=
 =?us-ascii?Q?xtatXmx+hQXBdzXvFrmA805cDFWwgnBQQzIE19kcXu43AgrXfLo+q5DL4NnF?=
 =?us-ascii?Q?olg/iPlo+u5a20M4bZWWSh4GNwqJirT2rEjYQqMnjDUV4t5jzqXeo/V6WNY6?=
 =?us-ascii?Q?dstDN/8JPqnEo5qsKzut2R6ZT8IXuhsNOSS/7m+m/4W6VYdEJ2RTKSewsJxA?=
 =?us-ascii?Q?JDoP4L/7uq3P1AaqkqOA8rVa6ezOuNcLI/kHMMm2B2dcWjjYiUbypxj5YDcl?=
 =?us-ascii?Q?Hu1KGXaK3mhReu91lowHU8dZK9QoGTvsRLbSQ7IZySvDqkLFBmgZyN2A4hBA?=
 =?us-ascii?Q?H/b9WyvzwEo5HyvtRmG/xOhSyqOdtFxDeILh7unlxj/dpW2jXV8pG4+x9S/4?=
 =?us-ascii?Q?1JdVQOyn0JSR7Ma3muxIerJYBtTvHoXOAP2XMMgnQQfQJPWZ8dsgwsAGg0Tj?=
 =?us-ascii?Q?Ab5wMDGOyGY7hl07NvF53sqqqmyy1FRKzAUncoNAEfHlNGbRqpnWU8rRU1KI?=
 =?us-ascii?Q?eT6dbkLVk4DMDFyK90rYVG+j30i+43nujY/2gBkQJYP4cJzQQWc1eC03nDER?=
 =?us-ascii?Q?Q8aGHCdxh7ltM4bJ1xHxM1a9k+OwGwQdXehvzl2TJQAnkjxgAfCTT1ExeAdo?=
 =?us-ascii?Q?xs7kiivOBovGw8jYDSRypQufQnlQ5ZH6yU8DgoUhMx5X0prS/Dp5WLK3fMbw?=
 =?us-ascii?Q?wBiTBYTyBnKitgjriOkEuzN1BQb4IVd2SglNT/xxVrpip/AhdEjoIfyOgr7/?=
 =?us-ascii?Q?xxS0F3dy2vhTqgcQt8ZlAy7KeKvdMsAVXFy0LbdzvKuE5Dsd/ti3+PtNj2TN?=
 =?us-ascii?Q?D+0vyH1qaF8+/WbCyjRGAixCv9FfQ6bdXdOneUWVcjFBhfeI0EqTIWLYn2C7?=
 =?us-ascii?Q?9A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <245C61458B8ABC4AB597891A7B0837B4@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?PrIkfysWUKHWme2UVv81+lOkqq4Rb4tblMY7SpD8nJAx48TC08wYJu+XoT9m?=
 =?us-ascii?Q?pwWygB1P3QIh1RMP1C7xXitzxPoi6xrIXu/VAv/3mxideWWZcI6kTyDLf/c/?=
 =?us-ascii?Q?+bYJXaxdEd3/2SttKWBwSmUBDAZi/6CJWq239CD1ReZWT+lp0kdvYZ5kVf+Q?=
 =?us-ascii?Q?YYGKX6jGNockiIl3qgaCpU20nDH/yQxDYBBHC+R7UpnfMCasyOHt75LJQgQg?=
 =?us-ascii?Q?7bjAsbxxiu4jvcFfniBV0QCdMBzroO+pYaTeagEqvnQVMTdqFBsjyteoOBlz?=
 =?us-ascii?Q?OFZX6MQko9svl5O1+Rd0y6a5k3Ce2KLFCgMf5XKTsJIskaLd4t2+bxCkf8mR?=
 =?us-ascii?Q?cA1ltwHSGO/n87GC4mj1RQC0FLd3kPcftz0hp07yYZOTqSrHnu7J9bi1FVTU?=
 =?us-ascii?Q?AHU80rRBi4YCFAFYaU0UJ7T/LNQoqc1yLDCBp1fbl4uQV+YIavGTsX/Q6W9d?=
 =?us-ascii?Q?IGYugD2KHwDtrfSnNe53juY0u4lMxtPA+Jyp5Frn9tYZZiy3si5MLwaO96hK?=
 =?us-ascii?Q?x4XadVPSNuB3/vpO1W5gY9Eqgxwt8h1yaXy0EiqiMLeJnTYE1kY48s0dMByQ?=
 =?us-ascii?Q?0pyC5nbFb37lAsxD4VNxSN4HFwO08vF42WMW4WP/JmbaBjF48YDTc8fplVnV?=
 =?us-ascii?Q?r+trHcGEIGc+Lc+dP5R/x/UYN7qdgBAavWVt0GD3bT0qo6/S6bwokCTOOdfr?=
 =?us-ascii?Q?dpLBFkymxgecj1WneiCp0in9Ylk1YJFHDrEVEahzlZ9NPN1ofW5JN5tKCxkT?=
 =?us-ascii?Q?OoWMvpIDScnZ0XjiCSnjO2vYXLr4IA0s3O5oUoR+DrQpb72XHDV4aQtlGhBa?=
 =?us-ascii?Q?YBIITKM9W6dMrW30cZoKzhvqq6xiLJw8hC6rtfQOgrLJ7EbMpLR8ajgXBz6s?=
 =?us-ascii?Q?3oAFt9atBgnJv0KRxlVZZNfVTudCy7yGafxOXbVNA4X1k2b1KYQFqoslqfKo?=
 =?us-ascii?Q?eYv4i8+HMDrQOvVqG80x/5VBDZbSAIucYyf8DB6mh8xaPNQGuNjkqakjbNEf?=
 =?us-ascii?Q?Che/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f4a0233-86e0-4f65-1a3c-08daf589aba4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2023 17:14:46.4861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nhkes+xSgZw/UfsmRrStemJ9MGeuoR5CQs7/6dsHhjtHTkL4RRQ5V88fTSwh/E+Ei4l+05lz32BWKw5eGoA+kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4457
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-13_08,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=938
 malwarescore=0 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301130116
X-Proofpoint-GUID: UZK33yPULDuIc8kuAmr1NFz-AHzFW3qQ
X-Proofpoint-ORIG-GUID: UZK33yPULDuIc8kuAmr1NFz-AHzFW3qQ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Jiri Slaby <jirislaby@kernel.org> [230112 11:57]:
> On 12. 01. 23, 16:43, Jiri Slaby wrote:
> > > and dump a kcore (kdump is set up).
> >=20
> > Going to trigger a dump now.
>=20
> Hmm, crash doesn't seems to work for 6.1, apparently. Once it did nothing=
,
> second time, it dumped an empty dir...

These was a patch added a few days ago to crash to support the maple
tree [1].  This might be why you are having issues?

1. https://www.mail-archive.com/crash-utility@redhat.com/msg09805.html

Thanks,
Liam=
