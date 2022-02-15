Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 416674B694C
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 11:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbiBOKaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 05:30:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbiBOKaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 05:30:08 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513DD2B183;
        Tue, 15 Feb 2022 02:29:58 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FANOGm001983;
        Tue, 15 Feb 2022 10:29:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=pBs6YC31+ei5SClrpEzkQXtnNHfZPoahZlvs7wXpNoM=;
 b=qNQX37NdAifNkFWtFJEeG5h+rCviCXLmzZg9CnjvdJhL/wgrz6oz1fYbtFcFGngVF3bo
 3QZ20vtHXObhcnQb41/SLM4fkgjn6hi5LuMS/xkBZZfCyg1k8GaLSDaETdMOkCWZOF2H
 fwrfUpeAduL6cckmngFaKjo+GoDOpSVCIWkkBn1OIPJtnPEqMX2XTV+ekqUmKJYysvmA
 by51uJFXXCnWpRmi1OE0t9yo3O0MHSG+ukKIQ0xCTO2zvZBuHm/Dbg6hEqHs5achajcB
 fWFyeQxClt1pWQJqSX7Kx+C56NZa+0u0HlA2alLJDqlRQCkXKrjj6c0jIdK9xxP472Cx jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8acpg39f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 10:29:57 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21FASPeR015798;
        Tue, 15 Feb 2022 10:29:57 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8acpg37x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 10:29:57 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21FATgGx017395;
        Tue, 15 Feb 2022 10:29:54 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3e64h9cpr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 10:29:54 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21FAINTw39387504
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 10:18:23 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE93F4C04A;
        Tue, 15 Feb 2022 10:28:43 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87F414C058;
        Tue, 15 Feb 2022 10:28:43 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.27.176])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 10:28:43 +0000 (GMT)
Message-ID: <cc1d20c1b53631271e51ed85e892fc6a9eee71d0.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v4 3/4] s390x: topology: Check the
 Perform Topology Function
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com
Date:   Tue, 15 Feb 2022 11:28:43 +0100
In-Reply-To: <1e9cfea2-c48c-fe2d-3e26-52ff0db1225b@linux.ibm.com>
References: <20220208132709.48291-1-pmorel@linux.ibm.com>
         <20220208132709.48291-4-pmorel@linux.ibm.com>
         <8dd704d23f8a14907ed2a7f28ec3ac52685ab96c.camel@linux.ibm.com>
         <c2dfd5c7-2602-e780-1f2b-402bff3c7c00@linux.ibm.com>
         <72d2bb5a-c0aa-6136-0900-58a0474334d9@linux.ibm.com>
         <1e9cfea2-c48c-fe2d-3e26-52ff0db1225b@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zDMOAZpBpuwbLRjcaz608VRgeTXWNhsN
X-Proofpoint-GUID: 4dSkHGBGE8Mq_xbuYxfmehMGxwZpFc1J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_03,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=839 clxscore=1015 spamscore=0 mlxscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-02-15 at 10:44 +0100, Pierre Morel wrote:
> > > > - second operand is ignored.
> > > 
> > > Which second operand?
> > 
> > Sorry got it
> 
> I was a little fast in my answer, twice.
> If the second operand is ignored, how would you like to check
> something 
> like that?
> We can check that the result of the instruction is identical for the 
> known effects the user can check what ever we put in there but how
> can 
> we know if it is really ignored?

Yes, there is no 100% guarantee. If you think there is no value or it's
too difficult to test for the value it adds, it is fine for me if you
leave it out.

Your suggestion sounds fine, though.
