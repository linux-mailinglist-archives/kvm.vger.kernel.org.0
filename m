Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08DBA702F04
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 16:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238942AbjEOOAq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 10:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238603AbjEOOAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 10:00:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D8E171F;
        Mon, 15 May 2023 07:00:39 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34FDeeoX008152;
        Mon, 15 May 2023 14:00:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : subject : from : message-id : date; s=pp1;
 bh=rcplVe4CUdr40r8BcWqxao8gDcFXnBHZJ3jHKLeGToY=;
 b=hjZyMg4RDW6lMPlDvsAyKqGr3kgmQfUZe/0MnXks8LB076k6w4gf2ZrPNFQTCAShhOHr
 CAEr9G+2HkyF0IfcZprIr8sccTYNr+mcjGnFCAauysOH8oa43iH5sKcnenE0Dx7KuPuC
 NGD6KXr4kF3D9rr7RsEWrWuX6p5TqfiA14EmbE3fD7KErZ4/KGcTck2WysnIvP4jthge
 Kk6LsIM7i3mmC9KUX3vYODModdqeq3ANgI3erEVjBXwOFRP0QrTOgQCP0QJNV/fWfA0k
 hlSy4MBHN+HdEc8HPjtG4fgNQ1HXwLp4xHQJb56/yYBlv9fKjJu7orQfav9CwCP0nZLV ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qknhgs4yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 May 2023 14:00:38 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34FDwrVw028156;
        Mon, 15 May 2023 14:00:38 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qknhgs4p5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 May 2023 14:00:37 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34F3I7xe015522;
        Mon, 15 May 2023 14:00:28 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qj264s3vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 May 2023 14:00:28 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34FE0O7250725146
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 May 2023 14:00:24 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 753B720083;
        Mon, 15 May 2023 14:00:24 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FA8420063;
        Mon, 15 May 2023 14:00:24 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.73.31])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 15 May 2023 14:00:24 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230515115311.1970-1-frankja@linux.ibm.com>
References: <168370369446.357872.12935361214141873283@t14-nrb> <20230515115311.1970-1-frankja@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v5] s390x: pv: Add sie entry intercept and validity test
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <168415922405.12463.14160729135637986664@t14-nrb>
User-Agent: alot/0.8.1
Date:   Mon, 15 May 2023 16:00:24 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3WxRS9waegPapbP3j3cgQ7vHJGXoFEKY
X-Proofpoint-GUID: vVPzi4yafu96l5wjtXCJpGu5MSYWrG-2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-15_10,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 bulkscore=0 impostorscore=0 phishscore=0 suspectscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305150117
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-05-15 13:53:11)
> The lowcore is an important part of any s390 cpu so we need to make
> sure it's always available when we virtualize one. For non-PV guests
> that would mean ensuring that the lowcore page is read and writable by
> the guest.
>=20
> For PV guests we additionally need to make sure that the page is owned
> by the guest as it is only allowed to access them if that's the
> case. The code 112 SIE intercept tells us if the lowcore pages aren't
> secure anymore.
>=20
> Let's check if that intercept is reported by SIE if we export the
> lowcore pages. Additionally check if that's also the case if the guest
> shares the lowcore which will make it readable to the host but
> ownership of the page should not change.
>=20
> Also we check for validities in these conditions:
>      * Manipulated cpu timer
>      * Double SIE for same vcpu
>      * Re-use of VCPU handle from another secure configuration
>      * ASCE re-use
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
