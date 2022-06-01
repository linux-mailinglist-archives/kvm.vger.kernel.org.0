Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1CF853A61F
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 15:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242256AbiFANsO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 09:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353299AbiFANsM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 09:48:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D2449F2D;
        Wed,  1 Jun 2022 06:48:11 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251DgQm2008193;
        Wed, 1 Jun 2022 13:48:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=AdF0i2v6MgTpDZILesOP+3ego3j9yhHlN3e6Y57/X3w=;
 b=RFQoqQgegIJdz8XFhtat2M+Oi5Yun90UFs8AH93iCManTZQZUp1m/aC8savTR7rXFWi1
 Ub3pRT7nVwT+5zfizf7GeTBwyqzXnF+D1GqoLKfGxB80Et2zm+h9zcgtGG/9E/Ot/Du6
 NmTYFUb8RfS5leXOBWS/a95e8GQUEEa7OqjLZlQm0mw2fl6yeW7h45K9XgxmPq2v/dcF
 IFB6bc25hZqH1XB3MtwzCvDIOOzWkE5MdRqDev/iqifuFn0g9JwTrK7o9tSDI6IqLNuh
 ngsZeULLYQkyMDee1NKG3rJrOQsmKD5fcBGeNJLOdtshEN+dVhcGTwLeOuPHIRMzBkSt xA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ge97q83m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 13:48:11 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 251DhGfF009632;
        Wed, 1 Jun 2022 13:48:11 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ge97q83kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 13:48:10 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 251Darms032271;
        Wed, 1 Jun 2022 13:48:08 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3gbc7h5q86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 13:48:08 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 251Dm5JD53805478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Jun 2022 13:48:05 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 422B45204F;
        Wed,  1 Jun 2022 13:48:05 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1 (unknown [9.152.224.44])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E98AF5204E;
        Wed,  1 Jun 2022 13:48:04 +0000 (GMT)
Date:   Wed, 1 Jun 2022 15:48:03 +0200
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, scgl@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3 1/1] s390x: add migration test for
 storage keys
Message-ID: <20220601154803.6bc22cac@li-ca45c2cc-336f-11b2-a85c-c6e71de567f1>
In-Reply-To: <ed8e3b8a-e7ac-d432-f733-82fdaf668c1b@redhat.com>
References: <20220531083713.48534-1-nrb@linux.ibm.com>
        <20220531083713.48534-2-nrb@linux.ibm.com>
        <ed8e3b8a-e7ac-d432-f733-82fdaf668c1b@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: E6u0LEc7fb2I469EZ_5Zy1tm6cedtJEt
X-Proofpoint-GUID: we-xpX31RyRR67_V2uXZCfn_MZnCFTjg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_04,2022-06-01_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 impostorscore=0 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206010060
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ooops, I just realized I accidentally sent an empty message this
morning. Sorry!

On Tue, 31 May 2022 10:55:27 +0200
Thomas Huth <thuth@redhat.com> wrote:

[...]
> > diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
> > new file mode 100644
> > index 000000000000..f846ac435836
> > --- /dev/null
> > +++ b/s390x/migration-skey.c
[...]
> > +	for (i = 0; i < NUM_PAGES; i++) {
> > +		report_prefix_pushf("page %d", i);
> > +
> > +		actual_key.val = get_storage_key(pagebuf[i]);
> > +		expected_key.val = i * 2;
> > +
> > +		/* ignore reference bit */
> > +		actual_key.str.rf = 0;
> > +		expected_key.str.rf = 0;  
> 
> If the reference bit gets always ignored, testing 64 pages should be
> enough? OTOH this will complicate the for-loop / creation of the key
> value, so I don't mind too much if we keep it this way.

Since it would make this thing more complex, I think I would just leave it as-is, 64 additional pages don't cost much.

[...]
> > +	if (test_facility(169)) {
> > +		report_skip("storage key removal facility is
> > active"); +
> > +		/*
> > +		 * If we just exit and don't ask migrate_cmd to
> > migrate us, it
> > +		 * will just hang forever. Hence, also ask for
> > migration when we
> > +		 * skip this test altogether.
> > +		 */
> > +		puts("Please migrate me, then press return\n");
> > +		(void)getchar();
> > +
> > +		goto done;
> > +	}
> > +
> > +	test_migration();
> > +
> > +done:  
> 
> 	} else {
> 		test_migration();
> 	}
> 
> to get rid of the goto?

Yes, makes sense, thank you.

[...]
> Either way:
> Reviewed-by: Thomas Huth <thuth@redhat.com>

Thanks.
