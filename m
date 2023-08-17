Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7253A77FB5B
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 17:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353418AbjHQP6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 11:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353415AbjHQP6X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 11:58:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA2E30E9;
        Thu, 17 Aug 2023 08:58:22 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37HFm7El004924;
        Thu, 17 Aug 2023 15:58:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=7VJB4vwPayz2mXH6KAzfg+0nxSxImVSJnAf9Fy3M5wM=;
 b=Wh9GeqN3wiNRqmxLksz8dnlG5+NeJoea1FZ2QMm6d0L92G5CoMAHlgWF4U6XNeR1ixj8
 6b1C9q7YVeTKC9L9uSe9qqlQxjm2v2pYZ8e/Lb4g9wd/IPn822DU2QzSDZ9bjNw3iRcY
 EkGMhin8Q5N/THgLLqUfqKRslV9Vr3P2UODHnOycWYT8o6+oiPDh20YkOWeos+ofhPDm
 kI80b5l+Xv3K3s3gLD9TjENrdpL5IpLZzUIdm2nXP9Lkor3VYtd2RdLjyjFCqDYjDcPV
 lKmIobNIJPdLpw1mhL53Cwrz4ypaqB+LXx7lQk/0uUb38sVhPvk92/IgjA7p60S4LoLC tg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3se30t1yn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Aug 2023 15:58:20 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37HENQNk019884;
        Thu, 17 Aug 2023 15:58:18 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sey3y9vy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Aug 2023 15:58:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M55gmYuIV210IvQI0RdJDSnbKzGXSO7AsW5mH5YvJp5UzhEJNKu57m6KPwN8UxTODXbPnSUO8wyDNzcO5CwOJuMtRwzzY1nDE6VXvhN2VHgJymz6+hZ6uDUiBz4a8STKuGSEtp2GYFRrjMA0zOPlEjYdtCCXT4fdO5RYgRnKyzdRBXHffx05mhswu2h4pnhlxYJahAKcQFxyEImcLn/O8Dr8PhDQh66r7fQQK53u4HZCdPnTW4G7gnve6jkCrsbj8tBLJToMIObgKMAC3W29ns2cvizZjTbJplSRDKe6/vDIPAwNku6mbNOyhn9xKQgLVPtNyM80UFGhmZEnQT+u/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7VJB4vwPayz2mXH6KAzfg+0nxSxImVSJnAf9Fy3M5wM=;
 b=dnEQdYzozAakR212zVzeH+XYIhWDZ6+Aq8zMHd8LP2NpW1LBE6ke6h1PZJv+olZ29020q+wTh33i2zVLFbX1SbLv0wgp/CMtQu9p77WMkVhx0XetPLl47znDX8djXRyvzLC2J1ULJY2o8RoyelIfMnQ70G8hA4YCjCyA8MEHStdWaejzzwGVsnf7i/6WCZHERkpD5zNAgEBJKYvQJZaxoh7UIO5FzE4sndWCxaZvtbn5KNTaij2QDY3BIdHTHYkhs4kYNvG4iYGlIdWVFVPdAbNzdbVQnWq/arMAt9yAAwXCfpbFriG8zGInV7ja7b9lOonxZlPc42HWyT0+iO1zIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7VJB4vwPayz2mXH6KAzfg+0nxSxImVSJnAf9Fy3M5wM=;
 b=WKxjcBV5FmbVpT6xrGMk21j/Co6BlEUn+qnVwNCXBmAUUbrwokWvjDdN44qol6emUt5FNNMqpYnih4y5e4OorZnBXgW+SJ2zyOkArcT3W1PbGoWkosvvYH+4GsfDAjIiJqGbqpWIKjcTDbXEk06bwvOkWv9qDpAdqogZoU/HHXc=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by IA1PR10MB6709.namprd10.prod.outlook.com (2603:10b6:208:41a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.31; Thu, 17 Aug
 2023 15:58:16 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::2990:c166:9436:40e]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::2990:c166:9436:40e%6]) with mapi id 15.20.6678.031; Thu, 17 Aug 2023
 15:58:16 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
CC:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Commit 'sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then
 sendpage' broke O_DIRECT over NFS
Thread-Topic: Commit 'sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then
 sendpage' broke O_DIRECT over NFS
Thread-Index: AQHZ0SMM7jGcAll+1kuqtwDJI+Lc8q/upMaAgAAAK4A=
Date:   Thu, 17 Aug 2023 15:58:16 +0000
Message-ID: <617E47EE-77B4-4904-A32B-56F3E50895CA@oracle.com>
References: <2d47431decaaf4bba0023c91ef0d7fd51b84333b.camel@redhat.com>
 <4DB1C27A-1B89-468A-9103-80DEDBF1A091@oracle.com>
In-Reply-To: <4DB1C27A-1B89-468A-9103-80DEDBF1A091@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.700.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|IA1PR10MB6709:EE_
x-ms-office365-filtering-correlation-id: 89a8c478-87eb-4d6a-2e60-08db9f3ac4bf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Skwz6yDNeYggK+vW7/EomDbJcDKEJxAGM6JgLv/F1ayPmMqxCmNyn2GziFuspfZGTNzDDikbiXx0Qqc0mgkmoPLmZxXcEqRYScrbLjo9sx4Grog0/rQJf5qaKedr/+ztR9a77mcCVsGuDAqQfOdIVO0UZj1Gr68QCrcl/CSo2UUNXwbo1UmHbZ/o4YPvujMw49QjghXc1XHDiUjE7qssZr7KIwU3IMjIbkxv9RhF3mIDx2Gi3aFuW3wbBn9IdeMRqRz5KqunYzNiVo4mFC2KCSYNUZ4p8/jnI5vs14dx46WrGcJ/NfatWNML9QcVlStFufNMTKBqXxjLyOnEtnPteCNtDkFOx60Qme0ejaoMbQzmyr9FIphEDoVt9ig/50yHM/p5U5syGjm9rSzVHuC/TPtiToW3ad23VTZ9dbqbvcLc/j3BrPLy7Hdcm5/vj2GjfjmApQyrTuufMGRPCUN3IcCzGxxsAXurK3BImL2j913pc94ojVfjZgeJS1hVzHf70czlFt0fXdm95Pd4++2rQMeMh2tXW1IOk5KDmeBlPJpP9mP8A749vf4sVfCV/afu/iZnNtvQaKpLEH5iPkmg1megqhyUY9/E0yowAJeu+R5oTkrAsHIb80XZOiAqFLoJqTUxbXalHzgBlJtvSWVCKawYkxeeCgU3SO9D31PNpZhpeZoUiEkQ29N+Qin5jlPe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(136003)(346002)(39860400002)(396003)(451199024)(186009)(1800799009)(36756003)(33656002)(86362001)(5660300002)(83380400001)(8936002)(8676002)(4326008)(53546011)(2906002)(41300700001)(26005)(6486002)(71200400001)(6506007)(2616005)(6512007)(122000001)(76116006)(478600001)(966005)(91956017)(64756008)(54906003)(66946007)(6916009)(316002)(66446008)(66556008)(38100700002)(66476007)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4iP1YXHvutoc7ZcCZD27C8WXYWi/ksSyc4HlvmVqRqCthAu52KGTD9sc2Tct?=
 =?us-ascii?Q?JyOm1AFxqcRa5ZNQEM1nTYCsGQsKVhNnuzoelvUGCA8sWM0P6232yRJv/mpu?=
 =?us-ascii?Q?60r73QZMWwCoL9ZkrtGyWiByovRTAlclraG9yt2wZP3WqUaPPWyEXQlV/kKi?=
 =?us-ascii?Q?qeKM0PFLXXZEgzxz6SsWdxirlJ3Zs7M8f8y8+hPGLiW3YSmOMbI0LpM7MTPK?=
 =?us-ascii?Q?E2Wquy/16gbpyVqqSB7clEADq67twoXksayQxmy1VBdtQZkeD4qwxlQlOimd?=
 =?us-ascii?Q?P7pqcQoWFp/c5sQmDDTN0+c4URyTobE9sAKQQYevMR4CPxz+1aB2KKDX3JjZ?=
 =?us-ascii?Q?CTqaQvvZrphrmQbzp+BkBRwqRVL2m9/gDWzUgDUXZ8kz9p9eiY4yUjRsm5dp?=
 =?us-ascii?Q?waZ7XRubGDPhwT2uAUL7B8YyTuWtuGoCaN75+AFIA2m5AJgtLMglsVCUr3Tq?=
 =?us-ascii?Q?e+iIGPG3iNqUzh8tr+4j6xeUWeM59icGa6D7kMJ+j4U+VrVL3C912YIIfLot?=
 =?us-ascii?Q?PGEcNY2WNyi8N7lZO8oiIZKY7KEPS3T/pqSfahGog/ap026k/kVLUmE5Avgy?=
 =?us-ascii?Q?810NtFL9Q21CUzLhJyZwluU1N+rAc/Tt5jD4EOLvhQ/FgWKv6Co4oZ3hNCUt?=
 =?us-ascii?Q?ZtabkcThuvrp0uY1TTIhXyoZPkbagjCVcjz/7g9rXUPeE+ryX2rV/DlTLTzG?=
 =?us-ascii?Q?d/LgdAdFg8tHiRGQwnDYE8vaMtXmhqB9WwDOhtGzb+32e8z0ChI6i2l0qoC0?=
 =?us-ascii?Q?TtUyb+wq17l3dOmSAnREkFuSc5E78PqudWmBN60tE5lKQffQK2BVluEWIvP1?=
 =?us-ascii?Q?J+o8BgbE4LGWx9+pROFOku+HZtv+xprDCa8KYrns7J5NcxcJNn4jgQfK9CPw?=
 =?us-ascii?Q?oqIJXVgpevTYueIlMYmdbJNagt9FaJ8PocpOxMI2vSRWlBup8/Ki30VjVFjK?=
 =?us-ascii?Q?gCEZkrvVttGG1oi7uBjO2cgIPTbi+FahBSg6rpXBbG39VK07XhCnmBRmZCYH?=
 =?us-ascii?Q?sV8b70B5GvrmMWxCFt1fiWrkMH7616fXis50ZLPgwIPuzk6iohmLN32+dp38?=
 =?us-ascii?Q?goFWNDdln5OcbsIAgotyowXSTlB/0TLsncLy/Cz3W4Nqz8N1/wVV4GeTz4uJ?=
 =?us-ascii?Q?69bh4U+clUmPgTcPpW+6Vl12cRSnflYk32xqLylhWsDEMMGaSGwQxnedtFrR?=
 =?us-ascii?Q?YUQrKi40T5vHnRjvA1MhoNcReTVwGiqJ+MdRhbxNuJ/QKuT3GraJAZrUiLc7?=
 =?us-ascii?Q?gq+kXI0BwRvp/NsAfK8o5YAxtByDemYX1rwrgu6Khaq7Mdoqb/s9iTNN0QAL?=
 =?us-ascii?Q?8ewkOeBH8s7m/LH1Mvqwn4tqIN5jKnylED4gO2OwlOtFQs6U/wy8NPzGpm/j?=
 =?us-ascii?Q?Y4VszieWIOE2MMrx23daf0CgmUy00qB7TcXhdp08MF7cvJqrpGEpF6F7BQdq?=
 =?us-ascii?Q?Olrsr4ZhIzbHP3TS7qqBoO9/bJTl1kmcoFIXFdsa5TbpeJe8l4UkTq6MNUpf?=
 =?us-ascii?Q?CQw8DgvAX82nRBmhbI0nc+JKJDvrz42la2wcbYo9IHoCIIpj0AZqabzOAeSF?=
 =?us-ascii?Q?vME2xYhLatcf7+dHRty1KI/uQuYEXHkGR8GxOTomjK6nYT2YrkL8CSJO1ReU?=
 =?us-ascii?Q?mA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9EAEC40C0CF75E45B4BD4E9397BA0BD2@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 2fMQRGfwMDTBOuti0g/OQiNTlL/outU4+3auKiYyWnQpNZarHYfViqWrqhQT/4EVIKM7mh7EfY5ipU20w0eIdcnP7jEFsJml57W1psk/qdUbHMRvJ8wGIh2NytDnnOneOSpL4ADJSjTklVvSDsv/wBZ+0Qkg+h9qpZydPPxiYLm4oYWdpy6sjSPT1fRMLyVCefcLkyOyEb2euARTu9q/jJBjWSMSVRi+yRmEiA/oSBEvhLRegzJaAZ9drLnu3l3ri3TnHqpvEVP5F+2PFXxxDvPaCoTMsYZwBtoJ6Oi9vofkkBzO5cAMw8Htb4ih/a+fWYlKwcod1Rd5USja2DDzcLG0NCah00SZUzSH9oaZLdEgHfnnQ4ZRLEDohjQYfhuT5Fms+dM8aCRL/OYZnUNp4YGhcve9RCF2K2D6R4ZQdVev0txftLOG3zR+JOauLWrGvMn/yr0OIgRKfOfUysfqkC800n12oLFewKWWK9m+J1tMZTRsCQS7ra7pZgc8sAaFfFgq7AI0MBscYBxGB9TNRGMZp/s5+qnc6EVk+2RAig7rRvMDpzBRyBd+DllTrw3l9HttVAUHcfQHvNX/enNFKmX/iNHjK8b7gVjGjtzWpoWgaPR4WjHdH9hwG84yXRiczlcoOltulR84lx8b73BYi4bhGyahfKudgbDDeVFgfcrTea98Vi71fDLO+JMx+1Qgw1WFU5DGRkEfMEIc3q03UL9t73ZQKOI1nAjTJYtj8wRUddFkthL20ztDig2GLLM0r8N90KqUeOcjjgIU4QI5va7s+jvb8Q0Ca+xNCg1WSmE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89a8c478-87eb-4d6a-2e60-08db9f3ac4bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2023 15:58:16.0390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3SK/ecOm3zrfW+eSp9XkDpr5pSwjf4ka7K85z3VArS1eZif8yEaoNoUHkLVV/Wg/fRoO7XzR/q0PrsGsgdOhPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6709
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-17_10,2023-08-17_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308170142
X-Proofpoint-GUID: NkbtoaIUfrKvDsUy3hsJA7SBOai3dpUF
X-Proofpoint-ORIG-GUID: NkbtoaIUfrKvDsUy3hsJA7SBOai3dpUF
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Aug 17, 2023, at 11:57 AM, Chuck Lever <chuck.lever@oracle.com> wrote:
>=20
>=20
>=20
>> On Aug 17, 2023, at 11:52 AM, Maxim Levitsky <mlevitsk@redhat.com> wrote=
:
>>=20
>> Hi!
>>=20
>> I just updated my developement systems to 6.5-rc6 (from 6.4) and now I c=
an't start a VM=20
>> with a disk which is mounted over the NFS.
>>=20
>> The VM has two qcow2 files, one depends on another and qemu opens both.
>>=20
>> This is the command line of qemu:
>>=20
>> -drive if=3Dnone,id=3Dos_image,file=3D./disk_s1.qcow2,aio=3Dnative,disca=
rd=3Dunmap,cache=3Dnone
>>=20
>> The disk_s1.qcow2 depends on disk_s0.qcow2
>>=20
>> However this is what I get:
>>=20
>> qemu-system-x86_64: -drive if=3Dnone,id=3Dos_image,file=3D./disk_s1.qcow=
2,aio=3Dnative,discard=3Dunmap,cache=3Dnone: Could not open backing file: C=
ould not open './QFI?': No such file or directory
>>=20
>> 'QFI?' is qcow2 file signature, which signals that there might be some n=
asty corruption happening.
>>=20
>> The program was supposed to read a field inside the disk_s1.qcow2 file w=
hich should read 'disk_s0.qcow2'=20
>> but instead it seems to read the first 4 bytes of the file.
>>=20
>>=20
>> Bisect leads to the above commit. Reverting it was not possible due to m=
any changes.
>>=20
>> Both the client and the server were tested with the 6.5-rc6 kernel, but =
once rebooting the server into
>> the 6.4, the bug disappeared, thus I did a bisect on the server.
>>=20
>> When I tested a version before the offending commit on the server, the 6=
.5-rc6 client was able to work with it,
>> which increases the chances that the bug is in nfsd.
>>=20
>> Switching qemu to use write back paging also helps (aio=3Dthreads,discar=
d=3Dunmap,cache=3Dwriteback)
>> The client and the server (both 6.5-rc6) work with this configuration.
>>=20
>> Running the VM on the same machine (also 6.5-rc6) where the VM disk is l=
ocated (thus avoiding NFS) works as well.
>>=20
>> I tested several VMs that I have, all are affected in the same way.
>>=20
>> I run somewhat outdated qemu, but running the latest qemu doesn't make a=
 difference.
>>=20
>> I use nfs4.
>>=20
>> I can test patches and provide more info if needed.
>=20
> Linus just merged a possible fix for this issue. See:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/ maste=
r

In particular:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3Dc96e2a695e00bca5487824d84b85aab6aa2c1891


--
Chuck Lever


