Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1415358FB8F
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 13:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235019AbiHKLos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 07:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234420AbiHKLoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 07:44:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E66C910BB;
        Thu, 11 Aug 2022 04:44:46 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BBfwei001906;
        Thu, 11 Aug 2022 11:44:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type : subject :
 from : in-reply-to : date : cc : message-id : references : to :
 content-transfer-encoding : mime-version; s=pp1;
 bh=k8OxMey6CLg0GXntxVvBFhpJY5/zsW848Xv+A0GjS6s=;
 b=N2cM+DWhRVUbq/fJTKxUHNeWzMwuC1VF/Cf5xLd72K5f8Q9BtYpEfpLiTzIaF1TgUmFH
 RlTLBf+ZXw42RwJuIbBbTnkTZy8P6iQz9Jlp6hf9JkshETUbhLy7LxkJO6AjYWoSHdv3
 1sv1bDBUmQJyGCE9J89dWKLQEvEv5X+8uwDK/xagkBF1R+ScrjGCjXuCa2Ml6uxytMdh
 FtXS5NCAjYiZWQGfcy4RxBLRKAk0SCgZinTPrtOWClqgGgoav4QKUC2fMLSXN3QqiOVD
 PLgRmuW1ZH0+ekScsN4b6Qy6dnfVwsc8xG+4FIvsd2rGnv+ZOHm0yeiWhQeRuc2M2TJM zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hw14dr1x8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 11:44:41 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27BBgJO3002450;
        Thu, 11 Aug 2022 11:44:41 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hw14dr1w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 11:44:41 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27BBZTgm017387;
        Thu, 11 Aug 2022 11:44:38 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3huwvg1yra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 11:44:38 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27BBiahf26280314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 11:44:36 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7500B11C04A;
        Thu, 11 Aug 2022 11:44:36 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 823CD11C050;
        Thu, 11 Aug 2022 11:44:35 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.43.75.173])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Aug 2022 11:44:35 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Subject: Re: [5.19.0-next-20220811] Build failure drivers/vdpa
From:   Sachin Sant <sachinp@linux.ibm.com>
In-Reply-To: <CAGxU2F5V-qxurLSZhugvNLWkiDOM83tgKQrEUFB_PLd7=kTH3Q@mail.gmail.com>
Date:   Thu, 11 Aug 2022 17:14:34 +0530
Cc:     kvm@vger.kernel.org, linux-next@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Message-Id: <7137A7BC-1036-49A3-885B-FEBC7985871F@linux.ibm.com>
References: <A330513B-21C9-44D2-BA02-853327FC16CE@linux.ibm.com>
 <CAGxU2F5V-qxurLSZhugvNLWkiDOM83tgKQrEUFB_PLd7=kTH3Q@mail.gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Qoq6gJZ-p24hQfcSx8c9YSWViWxLr7kO
X-Proofpoint-ORIG-GUID: vn0zB7nDtYDwZaBLZs4PbZ8c3O9kA7fe
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_05,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=843 impostorscore=0 mlxscore=0 suspectscore=0 clxscore=1015
 adultscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2208110034
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 11-Aug-2022, at 3:45 PM, Stefano Garzarella <sgarzare@redhat.com> wrot=
e:
>=20
>> Date:   Wed Aug 10 11:43:47 2022 +0200
>>    vdpa_sim_blk: add support for discard and write-zeroes
>>=20
>=20
> Thanks for the report, I already re-sent a new series with that patch fix=
ed:
> https://lore.kernel.org/virtualization/20220811083632.77525-1-sgarzare@re=
dhat.com/T/#t

Thanks. That patch works for me.

- Sachin

